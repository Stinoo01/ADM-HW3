# Navigate to the directory containing TSV files
cd tsv_files

#Merge all the tsv files 
output_directory="../"  
merged_file="$output_directory/merged_courses.tsv"
touch "$merged_file"

# iterates over files in tsv_files folder matching the pattern *course_*.tsv and appends the content of each file to $merged_file
for file in *course_*.tsv; do   
    tail -n +1 "$file" >> "$merged_file"                        
done

merged_file=$(cat ../merged_courses.tsv) # open the new tsv file

# Find the country and the city with the most Master's Degrees 
max_country=$(echo -e "$merged_file" | awk -F'\t' '$8 == "MSc"{print $11}' | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2,$3}')  # extract country (value of 11th column) from each line where the 8th column contains "MSc", count the occurrences of each country, sort in decreasing order, take the first row (country with max MSc) and store the name 
max_count=$(echo -e "$merged_file" | awk -F'\t' '$8 == "MSc"{print $11}' | sort | uniq -c | sort -nr | head -n 1 | awk '{print $1}') # do the same and store the number of occurrences
echo "- Country with the most Master's Degrees: $max_country with $max_count Master's degrees"

max_city=$(echo -e "$merged_file" | awk -F'\t' '$8 == "MSc"{print $10}' | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}')  # extract city (value of 10th column) from each line where the 8th column contains "MSc", count the occurrences of each city, sort in decreasing order, take the first row (city with max MSc) and store the name 
max_count=$(echo -e "$merged_file" | awk -F'\t' '$8 == "MSc"{print $10}' | sort | uniq -c | sort -nr | head -n 1 | awk '{print $1}') # do the same and store the number of occurrences
echo "- City with the most Master's Degrees: $max_city with $max_count Master's degrees"


# Count the number of colleges offering Part-Time education
part_time_colleges=$(echo -e "$merged_file" | awk -F'\t' '$4 ~ /Part time/{print $2}' | sort -u | wc -l) # counts the number of unique values in the 2nd column (colleges) where the 4th column contains the string "Part time"
echo "- Number of colleges offering Part-Time education: $part_time_colleges"

# Calculate the percentage of courses in Engineering
total_courses=$(echo -e "$merged_file" | wc -l)  # counts the total number of lines, i.e. the number of courses
engineering_courses=$(echo -e "$merged_file" | awk -F'\t' '$1 ~ /Engineer/' | wc -l)  # count the number of lines where the first field contains the string "Engineer"
percentage_engineering=$(awk "BEGIN {printf \"%.2f\", ($engineering_courses/$total_courses) * 100}") # use awk to have a float number with two decimal places
echo "- Percentage of courses in Engineering:  $percentage_engineering%"