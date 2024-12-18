#!/bin/bash

# Check if the log file is provided as an argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <log_file>"
    exit 1
fi

LOG_FILE=$1
REPORT_FILE="log_report.txt"

# Check if the log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Log file '$LOG_FILE' not found!"
    exit 1
fi

# Generate report
echo "Generating report from log file: $LOG_FILE"
echo "--------------------------------------" > "$REPORT_FILE"
echo "Log Report Summary" >> "$REPORT_FILE"
echo "--------------------------------------" >> "$REPORT_FILE"

# Count total log entries
TOTAL_ENTRIES=$(wc -l < "$LOG_FILE")
echo "Total Log Entries: $TOTAL_ENTRIES" >> "$REPORT_FILE"

# Count log entries by level (INFO, WARNING, ERROR)
echo "Log Entries by Level:" >> "$REPORT_FILE"
for LEVEL in INFO WARNING ERROR; do
    COUNT=$(grep -c " $LEVEL " "$LOG_FILE")
    echo "  $LEVEL: $COUNT" >> "$REPORT_FILE"
done

# Extract and display the top 5 frequent error messages
echo "Top 5 Frequent Errors:" >> "$REPORT_FILE"
grep " ERROR " "$LOG_FILE" | cut -d' ' -f3- | sort | uniq -c | sort -nr | head -5 >> "$REPORT_FILE"

# Extract and display log entries grouped by date
echo "Log Entries by Date:" >> "$REPORT_FILE"
cut -d' ' -f1 "$LOG_FILE" | sort | uniq -c | sort -nr >> "$REPORT_FILE"

# Finalize report
echo "--------------------------------------" >> "$REPORT_FILE"
echo "Report saved to $REPORT_FILE"

