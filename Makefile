GEM := $(shell pwd | xargs basename)
gem:
	gem build $(GEM).gemspec

public:
	gem push $(shell ls -thd $(GEM)*.gem  | head -1)
