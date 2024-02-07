resource "aws_sfn_state_machine" "state_machine_main" {
  name       = "sdk-test-state-machine"
  role_arn   = aws_iam_role.state_machine_main_iam_role.arn
  definition = templatefile("${path.module}/templates/state_machine/main.asl.json", {})
}
