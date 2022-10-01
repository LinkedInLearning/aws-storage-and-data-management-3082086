import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

glueContext = GlueContext(SparkContext.getOrCreate())

employees = glueContext.create_dynamic_frame.from_catalog(
             database="EMPLOYEE_METADATA_DATABASE_NAME_HERE",
             table_name="EMPLOYEES_TABLE_TABLE_NAME_HERE")
print "Employee Row Count: ", employees.count()
employees.printSchema()

satisfaction = glueContext.create_dynamic_frame.from_catalog(
             database="SURVEY_METADATA_DATABASE_NAME_HERE",
             table_name="EMPLOYEE_SATISFACTION_TABLE_NAME_HERE")

# limit to certain fields
satisfaction = satisfaction.select_fields(['employee_id','overall_satisfaction','comments'])

print "Survey Row Count: ", satisfaction.count()
satisfaction.printSchema()

# do the join
joined_data = Join.apply(employees, satisfaction, 'id', 'employee_id')
print "Join count: ", joined_data.count()
joined_data.printSchema()
joined_data.toDF().show()


# Write new data frame to S3.
repartitioned = joined_data.toDF().repartition(1)
repartitioned.write.csv('s3://PRIMARY_DEMO_BUCKET_NAME_HERE/employee_satisfaction_single_file.csv')         
