local clusterParams = import '../clusterParams.libsonnet';
local defaultVars = import '../_templates/rocketmq/vars.libsonnet';
local Rocketmq = import '../_templates/rocketmq/index.libsonnet';

local instanceVars = {
	name: 'default',
};

local app = defaultVars + instanceVars;

Rocketmq(app)
