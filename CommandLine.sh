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

# Find the country and the city with the most Master's Degrees 
max_country=$(echo -e "$merged_file" | awk -F'\t' '$8 == "MSc"{print $11}' | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2,$3}')
max_count=$(echo -e "$merged_file" | awk -F'\t' '$8 == "MSc"{print $11}' | sort | uniq -c | sort -nr | head -n 1 | awk '{print $1}')
echo "- Country with the most Master's Degrees: $max_country with $max_count Master's degrees"

max_city=$(echo -e "$merged_file" | awk -F'\t' '$8 == "MSc"{print $10}' | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}')
max_count=$(echo -e "$merged_file" | awk -F'\t' '$8 == "MSc"{print $10}' | sort | uniq -c | sort -nr | head -n 1 | awk '{print $1}')
echo "- City with the most Master's Degrees: $max_city with $max_count Master's degrees"


# Count the number of colleges offering Part-Time education
part_time_colleges=$(echo -e "$merged_file" | awk -F'\t' '$4 ~ /Part time/{print $2}' | sort -u | wc -l)
echo "- Number of colleges offering Part-Time education: $part_time_colleges"

# Calculate the percentage of courses in Engineering
total_courses=$(echo -e "$merged_file" | wc -l)
engineering_courses=$(echo -e "$merged_file" | awk -F'\t' '$1 ~ /Engineer/' | wc -l)
percentage_engineering=$(awk "BEGIN {printf \"%.2f\", ($engineering_courses/$total_courses) * 100}")
echo "- Percentage of courses in Engineering: $percentage_engineering%"