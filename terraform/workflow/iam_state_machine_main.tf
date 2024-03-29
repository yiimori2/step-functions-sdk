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
      "states:StartExecution",
      "states:ListExecutions"
    ]
    resources = [
      "arn:aws:states:ap-northeast-1:106335325643:stateMachine:sdk-test-state-machine"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "states:DescribeExecution",
      "states:StopExecution"
    ]
    resources = [
      "arn:aws:states:ap-northeast-1:106335325643:execution:sdk-test-state-machine:*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "events:PutTargets",
      "events:PutRule",
      "events:DescribeRule"
    ]
    resources = [
      "arn:aws:events:ap-northeast-1:106335325643:rule/StepFunctionsGetEventsForStepFunctionsExecutionRule"
    ]
  }



  statement {
    effect = "Allow"
    actions = [
      "lambda:InvokeFunction"
    ]
    resources = ["arn:aws:lambda:ap-northeast-1:106335325643:function:hello-world"]
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
