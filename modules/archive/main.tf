data "archive_file" "authors_read_zip" {
  type        = "zip"
  source_dir  = "./authors_read" # Directory containing your lambda function code
  output_path = "../authors_read.zip"
}

data "archive_file" "courses_put_zip" {
  type        = "zip"
  source_dir  = "./courses_put" # Directory containing your lambda function code for putting item in DynamoDB
  output_path = "../courses_put.zip"
}

data "archive_file" "courses_update_zip" {
  type        = "zip"
  source_dir  = "./courses_update" # Directory containing your lambda function code for putting item in DynamoDB
  output_path = "../courses_update.zip"
}

data "archive_file" "courses_read_zip" {
  type        = "zip"
  source_dir  = "./courses_read" # Directory containing your lambda function code for putting item in DynamoDB
  output_path = "../courses_read.zip"
}

data "archive_file" "courses_read_one_zip" {
  type        = "zip"
  source_dir  = "./courses_read_one" # Directory containing your lambda function code for putting item in DynamoDB
  output_path = "../courses_read_one.zip"
}

data "archive_file" "courses_delete_zip" {
  type        = "zip"
  source_dir  = "./courses_delete" # Directory containing your lambda function code for putting item in DynamoDB
  output_path = "../courses_delete.zip"
}