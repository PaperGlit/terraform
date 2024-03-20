output "authors_read_arn" {
  value = aws_iam_role.authors_read_role.arn
}

output "courses_put_arn" {
  value = aws_iam_role.courses_put_role.arn
}

output "courses_read_arn" {
  value = aws_iam_role.courses_read_role.arn
}

output "courses_read_one_arn" {
  value = aws_iam_role.courses_read_one_role.arn
}

output "courses_delete_arn" {
  value = aws_iam_role.courses_delete_role.arn
}