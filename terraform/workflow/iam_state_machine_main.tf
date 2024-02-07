data "aws_iam_policy_document" "state_machine_main_assume_role_policy_document" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "state_machine_main_iam_role" {
  name               = "sdk-test-state-machine"
  assume_role_policy = data.aws_iam_policy_document.state_machine_main_assume_role_policy_document.json
}

data "aws_iam_policy_document" "state_machine_main_iam_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole",
      "states:DescribeExecution",
      "states:StopExecution"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "lambda:InvokeFunction"
    ]
    resources = ["arn:aws:lambda:ap-northeast-1:106335325643:hello-world"]
  }
}

resource "aws_iam_policy" "state_machine_main_role_policy" {
  name   = "sdk-test-state-machine"
  policy = data.aws_iam_policy_document.state_machine_main_iam_policy_document.json
}

resource "aws_iam_policy_attachment" "state_machine_main_role_policy" {
  name       = "skd-test-state-machine"
  roles      = [aws_iam_role.state_machine_main_iam_role.name]
  policy_arn = aws_iam_policy.state_machine_main_role_policy.arn
}
