class MainController < ApplicationController

	def index
		render action: :index
	end

	def espacio
		render action: :espacio
	end
end
