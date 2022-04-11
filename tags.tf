resource "newrelic_entity_tags" "demo_tag" {
    guid = newrelic_one_dashboard.DEMO_dashboard.guid

    tag {
        key = "application"
        values = ["demo-app"]
    }

    tag {
        key = "env"
        values = ["dev"]
    }
}