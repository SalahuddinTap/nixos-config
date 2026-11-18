#!/usr/bin/env bash
# Backup ~/projects to internal NVMe backup partition

SOURCE="/home/salahuddin/projects"
DEST="/mnt/recovery/backups/projects"
EXCLUDE_FILE="/home/salahuddin/.backup_exclude"

# Create exclude file if not exists
cat > "$EXCLUDE_FILE" << 'EOF'
*/node_modules/
*/.git/
*/__pycache__/
*/.cache/
*/target/
*/build/
*/dist/
*/.next/
*/.vercel/
*.log
*.tmp
*.swp
*~
EOF

echo "Backing up $SOURCE -> $DEST"
rsync -avh --progress --delete --exclude-from="$EXCLUDE_FILE" "$SOURCE/" "$DEST/"

echo "Done. Size:"
du -sh "$DEST"