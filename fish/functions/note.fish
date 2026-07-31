# Quick note taking
function note
    set note_file ~/.notes
    if test (count $argv) -gt 0
        echo (date "+%Y-%m-%d %H:%M:%S") "|" $argv >>$note_file
        echo "Note added: $argv"
    else
        if test -f $note_file
            cat $note_file
        else
            echo "No notes yet. Add one with: note 'your note here'"
        end
    end
end
