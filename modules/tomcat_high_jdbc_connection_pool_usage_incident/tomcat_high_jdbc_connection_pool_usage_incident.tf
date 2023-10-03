resource "shoreline_notebook" "tomcat_high_jdbc_connection_pool_usage_incident" {
  name       = "tomcat_high_jdbc_connection_pool_usage_incident"
  data       = file("${path.module}/data/tomcat_high_jdbc_connection_pool_usage_incident.json")
  depends_on = [shoreline_action.invoke_update_tomcat_pool_size]
}

resource "shoreline_file" "update_tomcat_pool_size" {
  name             = "update_tomcat_pool_size"
  input_file       = "${path.module}/data/update_tomcat_pool_size.sh"
  md5              = filemd5("${path.module}/data/update_tomcat_pool_size.sh")
  description      = "Increase the maximum size of the connection pool to allow for more simultaneous connections."
  destination_path = "/agent/scripts/update_tomcat_pool_size.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_update_tomcat_pool_size" {
  name        = "invoke_update_tomcat_pool_size"
  description = "Increase the maximum size of the connection pool to allow for more simultaneous connections."
  command     = "`chmod +x /agent/scripts/update_tomcat_pool_size.sh && /agent/scripts/update_tomcat_pool_size.sh`"
  params      = ["POOL_SIZE"]
  file_deps   = ["update_tomcat_pool_size"]
  enabled     = true
  depends_on  = [shoreline_file.update_tomcat_pool_size]
}

