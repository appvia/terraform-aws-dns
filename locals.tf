locals {
  replace_regex = "/[\\._\\s]/"

  normalised_rule_groups = {
    for group, config in var.resolver_rule_groups :
    group => merge(config, {
      name = replace(coalesce(config.name, group), local.replace_regex, "-")
      rules = [
        for rule in config.rules : merge(rule, {
          name = replace(coalesce(rule.name, rule.domain), local.replace_regex, "-")
        })
      ]
    })
  }

  normalised_rules = merge([
    for group, config in local.normalised_rule_groups : {
      for rule in config.rules :
      join("-", [config.name, rule.name]) => merge(rule, {
        group = group
      })
    }
  ]...)
}
