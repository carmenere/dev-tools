lsof:
ifneq ($(HOST),0.0.0.0)
	sudo lsof -nP -i4TCP@0.0.0.0:$(PORT) || true
endif
ifneq ($(HOST),localhost)
	sudo lsof -nP -i4TCP@localhost:$(PORT) || true
endif
	sudo lsof -nP -i4TCP@$(HOST):$(PORT) || true
