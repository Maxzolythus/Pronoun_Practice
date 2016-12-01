require './Play'
require './Options'

Shoes.app(title: "Pronoun Practice!", width: 400, height: 600, resizable: false) do
	background"58D" #"56F" .. "#12D"
	border "#0a1f4f", strokewidth: 10
	@current
	
	# The main menu for the application
	def main_menu
		
		stack(margin: 15) {
			title( "Pronoun Practice!",
					font: "Verdana",
					stroke: white
			)
			
			para "\n\n" # Creates space between title and buttons
			
			
			stack {
				play = button "Start Practicing!"
				play.click{
					@current.clear { choose_pronouns() }
				}
				para "" # Creates space between buttons
				options = button "Options."
				options.click {
					@current.clear { options_menu() }
				} 
				para ""
				quit = button "Quit."
				quit.click{
					exit()
				}
			}
		}
	end
	
	# Gets the @current variable
	# Doing this allows the current scene to be changed
  # Without creating a class
	def get_current
		@current
	end
	
	@current = main_menu()
	
end