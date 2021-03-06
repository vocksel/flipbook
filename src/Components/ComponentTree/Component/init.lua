local flipbook = script:FindFirstAncestor("flipbook")

local Roact = require(flipbook.Packages.Roact)
local hook = require(flipbook.hook)
local Directory = require(script.Directory)
local Story = require(script.Story)
local types = require(script.Parent.types)

local e = Roact.createElement

local defaultProps = {
	indent = 0,
}

type Props = typeof(defaultProps) & {
	node: types.Node,
	filter: string?,
	activeNode: types.Node?,
	onClick: ((types.Node) -> ())?,
}

local function Component(props: Props, hooks: any)
	local hasChildren = props.node.children and #props.node.children > 0

	local expanded, setExpanded = hooks.useState(false)
	local onClick = hooks.useCallback(function()
		if props.onClick then
			props.onClick(props.node)
		end

		if hasChildren then
			setExpanded(function(prev)
				return not prev
			end)
		end
	end, { setExpanded })

	local children = {
		UIListLayout = if hasChildren
			then e("UIListLayout", {
				SortOrder = Enum.SortOrder.Name,
			})
			else nil,
	}

	if hasChildren and props.node.children then
		for idx, child in ipairs(props.node.children) do
			children[child.name .. idx] = Roact.createElement(Component, {
				node = child,
				indent = props.indent + 1,
				filter = props.filter,
				activeNode = props.activeNode,
				onClick = props.onClick,
			})
		end
	end

	if props.filter and props.node.icon ~= "storybook" then
		local match = props.node.name:match(props.filter)

		if not match then
			return
		end
	end

	return e("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Size = UDim2.fromScale(1, 0),
	}, {
		UIListLayout = e("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),

		Node = if props.node.icon ~= "story"
			then e(Directory, {
				expanded = expanded,
				hasChildren = hasChildren,
				indent = props.indent,
				node = props.node,
				onClick = onClick,
			})
			else e(Story, {
				active = props.activeNode == props.node,
				indent = props.indent,
				node = props.node,
				onClick = onClick,
			}),

		Children = if expanded and hasChildren
			then e("Frame", {
				AutomaticSize = if expanded then Enum.AutomaticSize.Y else Enum.AutomaticSize.None,
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.fromScale(1, 0),
			}, children)
			else nil,
	})
end

Component = hook(Component, {
	defaultProps = defaultProps,
})

return Component
