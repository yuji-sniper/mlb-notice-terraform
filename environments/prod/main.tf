locals {
  env = "prod"
}

module "eventbridge_api" {
  source = "../../modules/eventbridge_api"

  name                                 = "${local.env}-mlb-tomorrow-game-notification"
  api_endpoint                         = "https://mlb-tomorrow-game.vercel.app/api/cron/notification"
  api_method                           = "POST"
  api_invocation_rate_limit_per_second = 10
  schedule_expression                  = "cron(0 12 * * ? *)" // 日本時間: 21:00
}
