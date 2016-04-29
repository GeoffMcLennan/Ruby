class Matrix

	attr_reader :rows
	attr_reader :cols
	attr_reader :matrix

	# Constructor, tests array for compatibility, then converts it into a matrix
	def initialize(my_arr)
		if testDim(my_arr)
			@matrix = my_arr
			@rows = 0
			@cols = 0
			
			# Calculates number of rows and columns
			@matrix.each do |row|
				@rows += 1
			end
			@matrix[0].each do |col|
				@cols += 1
			end
		else
			puts "Unable to create matrix."
		end
			
	end
	
	# Tests that the input is an array, and that it contains only numbers
	# Returns true if it is a valid array, false otherwise 
	def testDim(my_arr)
		# Checks the input is an array
		if my_arr.kind_of?(Array)
			sum = 0
			num_test = true
			my_arr.each do |row|
				sum += row.length
				
				row.each do |col|
					is_num = col.is_a? Numeric
					num_test = num_test && is_num
				end
			end
			avg_length = sum / my_arr.length
			
			# Checks the array contains only numbers
			if num_test
				# Checks that all rows are the same length
				return avg_length == my_arr[0].length
			else
				puts "Invalid input: Input array contains non-numeric values."
				return false
			end
		else
			puts "Invalid input: Input is not an array."
			return false
		end
	end
	private :testDim

	# Prints matrix row by row
	def to_s()
		@matrix.each do |row|
			row.each do |col|
			print "#{col}\t"
			end
			puts ""
		end
		return " "
	end
	
	# Adds this matrix to the matrix given in the parameter
	# Returns a new Matrix object.
	def add(other)
		if other.class == self.class
			if other.rows == @rows && other.cols == @cols
				new_arr = Array.new(@rows) { Array.new(@cols) }
				addMatrix = other.matrix
				
				# Add values into new array
				row = 0
				new_arr.each do |rows|
					col = 0
					rows.each do |cols|
						new_arr[row][col] = addMatrix[row][col] + @matrix[row][col]
						col += 1
					end
					row += 1
				end
				
				# Create and return new matrix
				nMatrix = Matrix.new(new_arr)
				return nMatrix
			else
				puts "Operation error: Matrix dimensions must be the same size."
			end
		else
			puts "Invalid input: Input is not an array."
		end
	end	
	
	# Subtracts another matrix from this matrix.
	# Returns a Matrix object.
	def subtract(other)
		if other.class == self.class
			if other.rows == @rows && other.cols == @cols
				new_arr = Array.new(@rows) {Array.new(@cols) }
				subMatrix = other.matrix
				
				# Subtract values into new array
				row = 0
				new_arr.each do |rows|
					col = 0
					rows.each do |cols|
						new_arr[row][col] = @matrix[row][col] - subMatrix[row][col]
						col += 1
					end
					row += 1
				end
				
				# Create and return new matrix
				nMatrix = Matrix.new(new_arr)
				return nMatrix
			else
				puts "Operation error: Matrix dimensions must be the same size."
			end
		else
			puts "Invalid input: Input is not an array."
		end
	end
	
	# Multiplies the matrix with the input matrix
	def mult(other)
		if other.class == self.class
			if other.rows == @cols
				new_arr = Array.new(@rows) { Array.new(other.cols) }
				prodMatrix = other.matrix
				
				# Calculates each point in the product matrix
				new_arr.each_with_index do |row, i|
					row.each_with_index do |col, j|
						new_arr[i][j] = getPoint(prodMatrix, i, j)
					end
				end
				
				nMatrix = Matrix.new(new_arr)
				return nMatrix
			else
				puts "Operation error: Matrix dimensions are not compatible with multiplication."
			end
		else
			puts "Invalid input: Input is not an array."
		end
	end
	
	# Support method for mult
	# Calculates the value of the given point in the product matrix
	def getPoint(mArray, row, col)
		point = 0
		@matrix[row].each_with_index do |num, i|
			point += @matrix[row][i] * mArray[i][col]
		end
		
		return point
	end
	private :getPoint
	
	def det() 
		if @rows == @cols
			if @rows == 2
				d = (@matrix[0][0] * @matrix[1][1]) - (@matrix[0][1] * @matrix[1][0])
				return d
			else
				d = 0
				@matrix.each_with_index do |row, i|
					
					# Clones matrix into a new array
					new_ary = Array.new(@rows)
					@matrix.each_index do |j|
						new_ary[j] = @matrix[j].clone
					end
					
					# Removes the first column and the targeted row from copied array
					new_ary.delete_at(i)
					new_ary.each do |x|
						x.delete_at(0)
					end
					
					# Determines if this determinant should be added or subtracted
					if i % 2 == 0
						mult = 1
					else
						mult = -1
					end
					
					# Adds (or subtracts) the product of the first number in the row, and the 
					# excluded determinant
					new_mat = Matrix.new(new_ary)
					d += mult * row[0] * new_mat.det
					
				end
				
				return d
			end
		else
			puts "Operation error: Matrix must have the same number of rows and columns."
		end
	end
	
	def transpose()
		trans = Array.new(@cols) { Array.new(@rows) }
		
		@matrix.each_with_index do |row, i|
			row.each_with_index do |col, j|
				trans[j][i] = col
			end
		end
		
		transMatrix = Matrix.new(trans)
		return transMatrix
	end
	
	def minors()
		min_arr = Array.new(@rows) { Array.new(@cols) }
		
		@matrix.each_with_index do |row, i|
			
			row.each_index do |j|
				new_ary = Array.new(@rows)
				@matrix.each_index do |x|
					new_ary[x] = @matrix[x].clone
				end
				
				new_ary.delete_at(i)
				new_ary.each do |y|
					y.delete_at(j)
				end
				
				newMat = Matrix.new(new_ary)
				min_arr[i][j] = newMat.det()
			end
		end
		minMat = Matrix.new(min_arr)
		return minMat
	end
	#private :minors
	
	def cofactor()
		new_arr = Array.new(@rows) { Array.new(@cols) }
		
		@matrix.each_with_index do |row, i|
			row.each_index do |j|
				if (i % 2 == 0 && j % 2 == 1) || (i % 2 == 1 && j % 2 == 0)
					new_arr[i][j] = -@matrix[i][j]
				else
					new_arr[i][j] = @matrix[i][j]
				end
			end
		end
		
		newMat = Matrix.new(new_arr)
		return newMat
	end
	#private :cofactor
	
	def inverse()
		adjoint = self.minors().cofactor().transpose()
		old_arr = adjoint.matrix
		
		new_arr = Array.new(@rows) { Array.new(@cols) }
		
		det = self.det()
		
		old_arr.each_with_index do |row, i|
			row.each_with_index do |col, j|
				new_arr[i][j] = Float(col) / det
			end
		end
		
		newMat = Matrix.new(new_arr)
		return newMat
		
	end

end

ary = [[1, 1, 1, 1, 1], [1, 1, 1, 1, 1], [1, 1, 1, 1, 1]]
ary2 = [[1, 1, 1], [1, 1, 1], [1, 1, 1], [1, 1, 1], [1, 1, 1]]
detary = [[1, 2, 3, 4], [4, 7, 6, 7], [5, 8, 9, 10], [11, 12, 13, 14]]
#ary = "Hello"
test = Matrix.new(ary)
test2 = Matrix.new(ary2)
det = Matrix.new(detary)

puts det.det()
puts det.inverse()
