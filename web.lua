print('Setting up WIFI...')
wifi.setmode(wifi.STATIONAP)
station_cfg={}
station_cfg.ssid="IOT_B104"
station_cfg.pwd="iot_b104"
station_cfg.save=false
wifi.sta.config(station_cfg)
wifi.sta.connect()
tmr.alarm(1, 1000, tmr.ALARM_AUTO, function()
    if wifi.sta.getip() == nil then
        print('Waiting for IP ...')
    else
        print('IP is ' .. wifi.sta.getip())
    tmr.stop(1)
    end
end)
 srv=net.createServer(net.TCP)
        srv:listen(80,function(conn)
            conn:on("receive",function(conn,payload)
                print("Heap = "..node.heap().." Bytes")
                print("Print payload:\n"..payload)

                -- write HTML
                head =   "<html><head><title>ESP8266 Webserver</title></head>"
                body =   "<body><h1>Welcome to Nodemcu</h1>"
                para =   "<p>The size of the memory available: "..tostring(node.heap()).." Bytes </p>"
                ending = "</body></html>"

                reply1 = head..body
                reply2 = para..ending
                payloadLen = string.len(reply1) + string.len(reply2)

                conn:send("HTTP/1.1 200 OK\r\n")
                conn:send("Content-Length:" .. tostring(payloadLen) .. "\r\n")
                conn:send("Connection:close\r\n\r\n")
                conn:send(reply1)
                conn:send(reply2)

                collectgarbage()
            end)

             conn:on("sent",function(conn)
                conn:close()
            end)

        end)

