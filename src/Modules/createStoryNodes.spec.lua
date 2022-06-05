return function()
	local flipbook = script:FindFirstAncestor("flipbook")
	local newFolder = require(flipbook.Mocks.newFolder)
	local types = require(script.Parent.Parent.types)
	local createStoryNodes = require(script.Parent.createStoryNodes)

	local mockStoryModule = Instance.new("ModuleScript")

	local mockStoryRoot = newFolder({
		Components = newFolder({
			["Story.story"] = mockStoryModule,
		}),
	})

	local mockStorybook: types.Storybook = {
		name = "MockStorybook",
		storyRoots = { mockStoryRoot },
	}

	it("should use an icon for storybooks", function()
		local nodes = createStoryNodes({ mockStorybook })

		local storybook = nodes[1]
		expect(storybook).to.be.ok()
		expect(storybook.icon).to.equal("storybook")
	end)

	it("should use an icon for container instances", function()
		local nodes = createStoryNodes({ mockStorybook })

		local storybook = nodes[1]
		local components = storybook.children[1]

		expect(components).to.be.ok()
		expect(components.icon).to.equal("folder")
	end)

	it("should use an icon for stories", function()
		local nodes = createStoryNodes({ mockStorybook })

		local storybook = nodes[1]
		local components = storybook.children[1]
		local story = components.children[1]

		expect(story).to.be.ok()
		expect(story.icon).to.equal("story")
	end)
end
