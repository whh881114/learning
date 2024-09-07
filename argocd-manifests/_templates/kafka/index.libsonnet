local dockerCredential = import '../_docker_credentials/index.libsonnet';

local Configmap = import './configmap.libsonnet';
local Pvc = import './pvc.libsonnet';
local Service = import './service.libsonnet';
local Statefulset = import './statefulset.libsonnet';


function(app)
	local pvc = Pvc(app);
	local service = Service(app);
	local statefulset = Statefulset(app);

	dockerCredential + service + pvc + statefulset
