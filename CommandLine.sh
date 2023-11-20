# Navigate to the directory containing TSV files
cd tsv_files

#Merge all the tsv files 
output_directory="../"  
merged_file="$output_directory/merged_courses.tsv"
touch "$merged_file"

for file in *course_*.tsv; do
    tail -n +1 "$file" >> "$merged_file"                                
done

merged_file=$(cat ../merged_courses.tsv) # open the new tsv file

# Find the country with the most Master's Degrees and the city
max_country=$(echo -e "$merged_file" | awk -F'\t' '$8 == "MSc"{print $11}' | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2,$3}')
echo "Country with the most Master's Degrees: $max_country"

max_city=$(echo -e "$merged_file" | awk -F'\t' -v country="$max_country" '$11 == country && $8 == "MSc"{print $10}' | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}')
echo "City in $max_masters_country with the most Master's Degrees: $max_city"


# Count the number of colleges offering Part-Time education
part_time_colleges=$(echo -e "$merged_file" | awk -F'\t' '$4 ~ /Part time/{print $1}' | sort -u | wc -l)
echo "Number of colleges offering Part-Time education: $part_time_colleges"

# Calculate the percentage of courses in Engineering
total_courses=$(echo -e "$merged_file" | wc -l)
echo "Total Courses: $total_courses"

engineering_courses=$(echo -e "$merged_file" | awk -F'\t' '$1 ~ /Engineering/' | wc -l)
echo "Engineering Courses: $engineering_courses"

percentage_engineering=$(awk "BEGIN {printf \"%.2f\", ($engineering_courses/$total_courses) * 100}")
echo "Percentage of courses in Engineering: $percentage_engineering%"