#Create IAM Role
resource "aws_iam_role" "jenkins_server_role" {
    name = "Training-jenkins_role"
    permissions_boundary  = "arn:aws:iam::536460581283:policy/boundaries/CustomPowerUserBound"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Sid    = ""
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            },
        ]
    })
}

# Attaching lambda, iam and S3 access policy to the jenkins_server_role
resource "aws_iam_role_policy_attachment" "S3_full_access_policy" {
    role       = aws_iam_role.jenkins_server_role.id
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_full_access_policy" {
    role       = aws_iam_role.jenkins_server_role.id
    policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
}

resource "aws_iam_role_policy_attachment" "iam_full_access_policy" {
    role       = aws_iam_role.jenkins_server_role.id
    policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_role_policy_attachment" "ec2_full_access_policy" {
    role       = aws_iam_role.jenkins_server_role.id
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}














































# #iam access policy
# resource "aws_iam_role_policy" "iam_access_policy" {
#     name = "jenkins_iam_access_policy"
#     role = aws_iam_role.jenkins_server_role.id
#     policy = jsonencode({
#         Version = "2012-10-17"
#         Statement = [
#             {
#                 Action = [
#                     "iam:*",
#                 ]
#                 Effect   = "Allow"
#                 Resource = "*"
#         },
#         ]
#     })
# }

# #S3 permissions policy
# resource "aws_iam_role_policy" "iam_access_policy" {
#     name = "jenkins_s3_access_policy"
#     role = aws_iam_role.jenkins_server_role.id
#     policy = jsonencode({
#         Version = "2012-10-17"
#         Statement = [
#             {
#                 Action = [
#                     "s3:*",
#                 ]
#                 Effect   = "Allow"
#                 Resource = "*"
#         },
#         ]
#     })
# }

# #lambda permissions policy
# resource "aws_iam_role_policy" "lambda_access_policy" {
#     name = "jenkins_s3_access_policy"
#     role = aws_iam_role.jenkins_server_role.id
#     policy = jsonencode({
#         Version = "2012-10-17"
#         Statement = [
#             {
#                 Action = [
#                     "s3:*",
#                 ]
#                 Effect   = "Allow"
#                 Resource = "*"
#         },
#         ]
#     })
# }
