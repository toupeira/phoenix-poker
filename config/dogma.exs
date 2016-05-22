use Mix.Config
alias Dogma.Rule

config :dogma,
  rule_set: Dogma.RuleSet.All,
  override: [
    %Rule.CommentFormat{ enabled: false },
    %Rule.ModuleDoc{ enabled: false },

    %Rule.LineLength{ max_length: 120 },
  ]
