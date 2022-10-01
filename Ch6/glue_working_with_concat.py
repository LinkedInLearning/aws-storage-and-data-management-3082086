import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from pyspark.sql.functions import concat, lit, col
from awsglue.dynamicframe import DynamicFrame
from awsglue.context import GlueContext
from awsglue.job import Job


args = getResolvedOptions(sys.argv, ["JOB_NAME"])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)

# Script generated for node S3 bucket
S3bucket_node1 = glueContext.create_dynamic_frame.from_catalog(
    database="demo_metadata",
    table_name="states_csv",
    transformation_ctx="S3bucket_node1",
)

temp_datasource = S3bucket_node1.toDF().withColumn("capital_concatenated", concat(col("capital"), lit(", "), col("state")))
datasource2 = DynamicFrame.fromDF(temp_datasource, glueContext, "datasource2")
datasource2.printSchema()

# Script generated for node ApplyMapping
ApplyMapping_node2 = ApplyMapping.apply(
    frame=datasource2,
    mappings=[
        ("state", "string", "state_name", "string"),
        ("abbreviation", "string", "abbreviation", "string"),
        ("capital_concatenated", "string", "capital_concatenated", "string")
    ],
    transformation_ctx="ApplyMapping_node2",
)

# Script generated for node MySQL table
MySQLtable_node3 = glueContext.write_dynamic_frame.from_catalog(
    frame=ApplyMapping_node2,
    database="demo_metadata",
    table_name="my_database_states",
    transformation_ctx="MySQLtable_node3",
)

job.commit()

