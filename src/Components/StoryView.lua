local flipbook = script:FindFirstAncestor("flipbook")

local Roact = require(flipbook.Packages.Roact)
local hook = require(flipbook.hook)
local types = require(script.Parent.Parent.types)
local useStory = require(flipbook.Hooks.useStory)
local StoryViewNavbar = require(flipbook.Components.StoryViewNavbar)
local StoryControls = require(flipbook.Components.StoryControls)
local StoryMeta = require(flipbook.Components.StoryMeta)
local StoryPreview = require(flipbook.Components.StoryPreview)

local e = Roact.createElement

type Props = {
	loader: any,
	story: ModuleScript,
	storybook: types.Storybook,
}

local function StoryView(props: Props, hooks: any)
	local story = useStory(hooks, props.story, props.storybook, props.loader)

	return e("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
	}, {
		UIListLayout = e("UIListLayout", {
			Padding = UDim.new(0, 50),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),

		StoryViewNavbar = story and e(StoryViewNavbar, {
			layoutOrder = 1,
		}),

		Content = story and e("Frame", {
			Size = UDim2.fromScale(1, 0),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = 2,
		}, {
			UIListLayout = e("UIListLayout", {
				Padding = UDim.new(0, 20),
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),

			StoryMeta = story and e(StoryMeta, {
				layoutOrder = 2,
				story = story,
				storyModule = props.story,
			}),

			StoryPreview = story and e(StoryPreview, {
				layoutOrder = 3,
				story = story,
				storyModule = props.story,
			}),

			StoryControls = story and e(StoryControls, {
				layoutOrder = 4,
			}),
		}),
	})
end

return hook(StoryView)
