require './Play'
# The first options menu, holds all of the buttons that navigate
# that allow you to different areas to change the game.
# Returns a stack containing the menu
def options_menu
	
	#if get_pronoun_list.nil?
	init_pronouns()
	#end
	
	stack {
		
		get_current().style(margin: 15)
		
		title("Options:",
			font: "Verdana",
			stroke: white
				
		)
		
		para "\n\n" # Creates space between title and buttons
		
		add_pronouns_btn = button "Add Pronouns"
		add_pronouns_btn.click {
			get_current().clear { add_pronouns() }
		}
		
		para ""
		
		del_pronouns_btn = button "Delete Pronouns"
		del_pronouns_btn.click {
			get_current().clear { del_pronouns() }
		}
		
		para ""
		
		add_sent = button "Add Sentences"
		add_sent.click{
			get_current().clear { choose_sent_type() }
		}
		
		para ""
		
		del_sent = button "Delete Sentences"
		del_sent.click{
			get_current().clear { del_sentences() }
		}
		
		para ""
		
		back = button "Back"
		back.click{
			get_current().style(margin: 0)
			get_current().clear { main_menu() }
		}
	}
end

# Adds new pronouns that you can practice with
# Returns a stack that will allow you to add to the pronoun_list
def add_pronouns
	stack{
		title("Add Pronouns:",
				font: "Verdana",
				stroke: white	
		)
			
		para ""
		
		para("Subject:", font: "Verdana", stroke: white)	
		sub = edit_line
		
		para ""
		
		para("Object:", font: "Verdana", stroke: white)
		obj = edit_line
		
		para ""
		
		para("Pocessive:", font: "Verdana", stroke: white)
		pos = edit_line
		
		para ""
		
		flow{
			submit = button "Submit"
			submit.click{
				entry = sub.text() + "/" + obj.text() + "/" + pos.text()
				
				pronoun_file = File.open("./Pronouns/addedPronouns.txt", "a")
				pronoun_file.write(entry)
				pronoun_file.close()
				
				get_current().clear { options_menu() }
				
			}
			
			back = button "Back"
			back.click{
				get_current().clear { options_menu() }
			}
		}
	}
		
end

# Deletes pronouns from the pronoun list
# Returns a stack that allows you to delete pronouns from the pronoun_list
def del_pronouns
	stack{
		title("Delete Pronouns:",
				font: "Verdana",
				stroke: white	
			)
			
		if get_pronoun_list().size > 4 # Allows only added pronouns to be deleted
			
			get_pronoun_list[4..-1].each do |el|
				
				pronoun_button = button el
				pronoun_button.click{
					File.rename("./Pronouns/addedPronouns.txt", "./Pronouns/tempaddedPronouns.txt")
					
					# Renames the current file, and writes everything that's not the deleted element to a new file
					File.open("./Pronouns/tempaddedPronouns.txt", "r") do |read_f| 
						File.open("./Pronouns/addedPronouns.txt", "w") do |write_f|
							read_f.each do |line|
								if line != el
									write_f.write(line)
								end
							end
						end
					end
					
					File.delete("./Pronouns/tempaddedPronouns.txt")
					get_pronoun_list().delete(el)
					
					get_current().clear { options_menu() } # Refresh the stack
				}
				para ""	
			end
		else
			para("No pronouns available for deletion!", font: "Verdana", stroke: white)
		end
		
		back = button "Back"
		back.click{
			get_current().clear { 
			options_menu() }
		}
		
	}
end

# Choosing the conjugation the sentence is using 
# so that it can be properly sorted and graded
def choose_sent_type
	stack{
		title("What Conjugation is Your Sentence Using?:",
				font: "Verdana",
				stroke: white	
		)
		flow{ 
			@sub = radio :sent 
			para strong("Subject", font: "Verdana", stroke: white) 
			}
		flow{ 
			@ob = radio :sent 
			para strong("Object", font: "Verdana", stroke: white) 
			}
		flow{ 
			@po = radio :sent 
			para strong("Pocessive", font: "Verdana", stroke: white) 
			}
		
		flow{
			submit = button "Submit"
			submit.click{
				if @sub.checked?()
					get_current().clear { add_sentences("Subject") }
				elsif @ob.checked?()
					get_current().clear { add_sentences("Object") }	
				elsif @po.checked?()
					get_current().clear { add_sentences("Pocessive") }	 
				end
			}
				
			back = button "Back"
			back.click{
				get_current().clear { options_menu() }
			}
		}
	}
end

# Adds sentences to the game
# Folder = the name of the folder
def add_sentences(folder)
	stack{
		@filename = ""
		@sent_num = 0
		num = 0
		title("Add Sentences:",
				font: "Verdana",
				stroke: white	
		)
		# Adds by using a text box
		para("Add by keyboard inout:", font: "Verdana", stroke: white)
		@add = edit_box
		
		# Adds by using a file
		para("Add by using a file:", font: "Verdana", stroke: white)
		open_btn = button "Open file!"
		@file_para = para ""
		
		open_btn.click{
			@filename = ask_open_file()
			if File.extname(@filename) == ".txt"
				@file_para.replace @filename
			else # Then the file is not a text file, and therefore can't be parsed.
				alert "ERROR: Not a .txt file. Please choose another file."
				@filename = ask_open_file()
			end
		}
		
		flow{
			submit = button "Submit"
			submit.click{
				if @filename != "" or @add.text() != ""
					# Overwriting the previous count
					File.rename("count.txt", "temp_count.txt")

					File.open("temp_count.txt", "r") do |read|
						read.each do |count|
							@sent_num = count.to_i
							@sent_num += 1
						end
						File.open("count.txt", "w") do |new_c|
							new_c.write(@sent_num)
						end
					end
					File.delete("temp_count.txt")
					
					if @filename != ""
						# Then there is a file.
						FileUtils.cp(@filename, "./Sentences/" + folder)
						
						File.rename("./Sentences/" + folder + "/" + @filename.basename, "./Sentences/" + folder + "/added_sent_" + @sent_num + ".txt")
					elsif @add.text() != ""
						# Then there is a sentence within the text box.
						alert "./Sentences/" + folder + "/added_sent_" + @sent_num.to_s + ".txt"
						File.open("./Sentences/" + folder + "/added_sent_" + @sent_num.to_s + ".txt", "w") do |line|
							line.write(@add.text)
						end
					end
				
				get_current().clear { options_menu() }
					
				else
					alert "ERROR: Please enter data into one of the fields."
				end
			}
			
			back = button "Back"
			back.click{
				get_current().clear { 
				options_menu() }
			}
		}
	}
end

#Deletes sentences from the game
def del_sentences
	title("Delete Sentences:",
				font: "Verdana",
				stroke: white	
		)
		
	folders = ["Subject", "Object", "Possessive"]
	sents = []

	folders.each do |folder| # Populate the sents list with added_sent files
		content = Dir["./Sentences/" + folder + "/*"]
		content.each do |file|
			if /added_sent_/.match(file)
				sents.push(file)
			end
		end
	end
		
	sents.each do |sent|
		sent_btn = button sent
		sent_btn.click{
			get_current().clear { view_sent(sent) }
		}
	end
	
	back = button "Back"
		back.click{
			get_current().clear { 
			options_menu() }
		}
end

# Displays a sentence sent and allows you to delete it.
# sent = path to the sentence
def view_sent(sent)
	@content = ""
	
	File.open(sent, "r") do |read|
		read.each do |line|
			@content += line
		end
	end
	
	title(@content,
				font: "Verdana",
				stroke: white	
		)
		
	
	flow{
		back = button "Back"
		back.click{
			get_current().clear { 
			options_menu() }
		}
		
		del = button "Delete"
		del.click{
			File.delete(sent)
			# Decrement count.txt
			
			get_current().clear { options_menu() }
		}
	}
end