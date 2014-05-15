core:module("CoreInputLayerDescriptionPrioritizer")
Prioritizer = Prioritizer or class()
function Prioritizer:init()
	self._layer_descriptions = {}
end

function Prioritizer:add_layer_description(input_layer_description_description)
	self._layer_descriptions[input_layer_description_description] = input_layer_description_description
	if not self._layer_description or input_layer_description_description:priority() < self._layer_description:priority() then
		self._layer_description = input_layer_description_description
	end

end

function Prioritizer:remove_layer_description(input_layer_description_description)
