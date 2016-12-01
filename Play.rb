#Shoes.app(width: 400, height: 600) do
#class Play
	
	# Initializes the pronouns list.
	def init_pronouns
		@pronoun_list = ["they/them/their", "ze/zem/zyr", "xe/xem/xyr", "ne/nem/nir"]
		@pronouns = Hash.new(3)
		@curr_p = 1
		@max_score = 10
		@score = 0
		#@prev_vistied = Array.new
		@curr_dir
		@conjugation = ["Subject", "Object", "Possessive"]
		
		# Add pronouns from saved storage to the list
		File.open("./Pronouns/addedPronouns.txt", "r") do |file|
			file.each_line do |line|
				@pronoun_list << line
			end
		end
	end
	
	# Choose the pronouns that you want to use for the current seesion
	# Returns the stack that allows you to choose your pronouns
	def choose_pronouns
		
		init_pronouns()
		
		get_current().style(margin: 15) 
		
		#choice
		stack{
			title("Choose a pronoun to practice with:",
					font: "Verdana",
					stroke: white
			)
			
			
			@pronoun_list.each do |el| # Creates a hash with conjugations as keys and Pronouns as Values
			
				pronoun_button = button el
				pronoun_button.click{
					@pronouns = @conjugation.zip(el.split('/')).to_h
					get_current().clear { play() }
				}
				para ""
				
			end
			
			back = button "Back"
			back.click{
				get_current().style(margin: 0)
				get_current().clear { main_menu }
			}
		}
	end
	
	# The practice session
	# Returns a stack where you practice pronouns using a sentence
	# From the Sentences directory, that is selected at random
	def play
		
		stack(width: 400){
			if @curr_p <= @max_score # Then the game is in progress.
				get_current().style(margin: 0)
				folders = Dir["./Sentences/*"]
				
				num = rand(0...folders.size()) # Picking a random folder to pick a sentence from
				stack(margin: 0) {
					background "#0a1f4f"
					
					score_text = para(strong(@score.to_s)).style(stroke: "#00b8e6", size: "large")
					
					folder = Dir[folders[num] + "/*.txt"]
					num2 = rand(0...(folder.size())) # Picking a random file
					File.open(folder[num2]) do |file|
						file.each_line do |line|
							#if !@prev_vistied.include? line
								title(line,
								font: "Verdana",
								stroke: white
								)
								#@prev_vistied.push(line)
							#end
						end
					end
					
					para("Select the correct pronoun:").style(stroke: white)
				}
				para ""
				# Directory of current file
				@curr_dir = File.basename(folders[num]) 
				stack(margin: 15){
					@pronouns.keys.each do |key|
						pronoun_button = button @pronouns[key]
						pronoun_button.click {
							if key == @curr_dir # You selected the correct answer
								@score += 1
								alert("Correct!")
							else
								alert("Incorrect!")
							end
							@curr_p += 1
							get_current().clear { play() }
						}
						para "" # Space between buttons
					end
				}
			else # Then the game has ended
				stack{
					background "#0a1f4f"
					title("Game over!",
							font: "Verdana",
							stroke: white)
					subtitle("Your score was " + @score.to_s + " out of " + @max_score.to_s).style(stroke: white)
				}
				stack(margin: 15){
					main_m = button "Return to main menu"
					main_m.click {
						get_current().style(margin: 0)
						get_current().clear { main_menu() }
					}
					
					para ""
					
					play_again = button "Play again?"
					play_again.click {
						get_current().clear { choose_pronouns() }
					}
					
					para ""
					
					quit = button "Quit"
					quit.click{
						exit()
					}
				}
				
			end
		}
	end

	def get_pronoun_list
		@pronoun_list
	end
#end