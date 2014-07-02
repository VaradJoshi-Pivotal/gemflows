class FlowsController < ApplicationController
  def show
  end

  def getservergroups
        begin
            # Prep the connection
            Java::com.pivotal.gemfirexd.jdbc.ClientDriver
            userurl = "jdbc:gemfirexd://localhost:1527/"
            conn = java.sql.DriverManager.get_connection(userurl, "app", "app")

            # Get the servergroups
            stmt = conn.create_statement
            query = "select id, servergroups from sys.members where kind != 'locator(normal)'"
            # Execute the query
            rsS = stmt.execute_query(query)

            # iterate over the resultset. 
			servers = Array.new
            while (rsS.next) do
				server = Array.new
                server.push(rsS.getObject("id"))
                server.push(rsS.getObject("servergroups"))
				servers.push(server)
            end
            stmt.close
        end
        # Close off the connection
        conn.close
        render json: {servers: servers}
  end

  def getflows
        begin
            # Prep the connection
            Java::com.pivotal.gemfirexd.jdbc.ClientDriver
            userurl = "jdbc:gemfirexd://localhost:1527/"
            conn = java.sql.DriverManager.get_connection(userurl, "app", "app")

            # Get the flows
            stmt = conn.create_statement
            query = "select id, deploy_descriptor from sys.sysflows"
            # Execute the query
            rsS = stmt.execute_query(query)

            # iterate over the resultset. 
			flows = Array.new
            while (rsS.next) do
				flow = Hash.new
                flow["id"] = rsS.getObject("id")
                flow["deploy_descriptor"] = rsS.getObject("deploy_descriptor")
				flows.push(flow)
            end
            stmt.close
        end
        # Close off the connection
        conn.close
        render json: {flows: flows}
  end

end
