function(app)
	local conf = |||
    tickTime=2000
    initLimit=10
    syncLimit=5
    dataDir=/data
    dataLogDir=/datalog
    clientPort=2181
    server.1=%s-0.%s:2888:3888
    server.2=%s-1.%s:2888:3888
    server.3=%s-2.%s:2888:3888
	||| % [app.name, app.name, app.name, app.name, app.name, app.name];

	conf