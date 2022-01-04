local Llama = require(script.Parent.Parent.Packages.Llama)
local Roact = require(script.Parent.Parent.Packages.Roact)
local RoactHooks = require(script.Parent.Parent.Packages.RoactHooks)
local styles = require(script.Parent.Parent.styles)
local useStory = require(script.Parent.Parent.Hooks.useStory)

type Props = {
	story: ModuleScript?,
}

local function StoryView(props: Props, hooks: any)
	local storyParent = hooks.useBinding(Roact.createRef())
	local err, setErr = hooks.useState(nil)
	local story = useStory(hooks, props.story)

	hooks.useEffect(function()
		local tree: table

		if story then
			local success, result = pcall(function()
				tree = Roact.mount(story.story, storyParent:getValue(), story.name)
			end)

			if success then
				setErr(nil)
			else
				setErr(result)
			end
		end

		return function()
			if tree then
				Roact.unmount(tree)
			end
		end
	end, { story, storyParent })

	if not story or err then
		return Roact.createElement(
			"TextLabel",
			Llama.Dictionary.join(styles.TextLabel, {
				Text = if story then "Select a story to preview it" else err,
				TextScaled = true,
				Size = UDim2.fromScale(1, 1),
				AutomaticSize = Enum.AutomaticSize.None,
			})
		)
	end

	return Roact.createElement("ScrollingFrame", Llama.Dictionary.join(styles.ScrollingFrame, {}), {
		Meta = Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
		}, {
			Summary = Roact.createElement("Frame", {
				Size = UDim2.fromScale(1, 0.2),
			}),

			Controls = Roact.createElement("Frame", {
				Size = UDim2.fromScale(1, 0.3),
			}),
		}),

		Preview = Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			[Roact.Ref] = storyParent,
		}),
	})
end

return RoactHooks.new(Roact)(StoryView)
