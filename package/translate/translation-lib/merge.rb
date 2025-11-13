require_relative 'color'

PROJECT_ROOT = File.expand_path('../../', __dir__)
PO_DIR       = File.join(PROJECT_ROOT, 'translate')
TEMPLATE     = File.join(PO_DIR, 'template.pot')
STATUS_FILE  = File.join(PO_DIR, 'Status.md')

def parse_entries(lines)
    entries = []
    entry = []
    lines.each do |line|
        if line.strip.empty?
            entries << entry unless entry.empty?
            entry = []
        else
            entry << line
        end
    end
    entries << entry unless entry.empty?
    entries
end

def extract_id(entry)
    line = entry.find { |l| l.start_with?('msgid') }
    return nil unless line
    line.sub(/^msgid\s*/, '').strip
end

Color.echo "[merge] Updating .po files...", :cyan

unless File.exist?(TEMPLATE)
    Color.echo "[merge] Missing template.pot at #{TEMPLATE}", :red
    exit 1
end

template_lines   = File.readlines(TEMPLATE)
template_entries = parse_entries(template_lines)
template_entries.reject! { |e| extract_id(e) == '""' }

Dir.glob("#{PO_DIR}/*.po").each do |po_path|
    Color.echo "[merge] Updating #{File.basename(po_path)}", :blue

    po_lines = File.readlines(po_path)
    po_entries = parse_entries(po_lines)
    po_entries.reject! { |e| extract_id(e) == '""' }

    seen = {}
    deduped_po = []
    po_entries.each do |entry|
        id = extract_id(entry)
        if seen[id]
            Color.echo "  - Removed duplicate: #{id}", :dim
            next
        end
        seen[id] = true
        deduped_po << entry
    end

    po_ids  = deduped_po.map { |e| extract_id(e) }
    pot_ids = template_entries.map { |e| extract_id(e) }
    new_ids = pot_ids - po_ids

    Color.echo "New entries to add: #{new_ids.size}", :cyan
    new_ids.each { |id| Color.echo "    + #{id}", :yellow }

    new_entries = template_entries.select { |e| new_ids.include?(extract_id(e)) }.map do |entry|
        entry.map { |line| line.start_with?('msgstr') ? "msgstr \"\"\n" : line }
    end

    merged = (deduped_po + new_entries).map { |e| e.join }.join("\n\n") + "\n"
    File.write(po_path, merged)
end

Color.echo "[merge] Done merging messages", :green
Color.echo "[merge] Translation progress:", :cyan

template_count = template_entries.count

rows = []
rows << "| Locale   | Lines   | % Done |"
rows << "|----------|---------|--------|"
rows << "| Template | #{template_count.to_s.rjust(7)} |        |"

Dir.glob("#{PO_DIR}/*.po").sort.each do |po_path|
    locale = File.basename(po_path, '.po')
    po_lines = File.readlines(po_path)
    po_entries = parse_entries(po_lines)
    po_entries.reject! { |e| extract_id(e) == '""' }

    translated = po_entries.count do |entry|
        entry.any? { |l| l.start_with?('msgstr') && l !~ /^msgstr\s*""\s*$/ }
    end

    percent      = ((translated.to_f / template_count) * 100).round
    line_str     = "#{translated}/#{template_count}"
    percent_str  = "#{percent}%".rjust(6)

    Color.echo "  #{locale.ljust(8)} #{line_str.ljust(10)} #{percent_str}", :blue
    rows << "| #{locale.ljust(8)} | #{line_str.rjust(7)} | #{percent_str} |"
end

File.write(STATUS_FILE, rows.join("\n") + "\n")
Color.echo "[merge] Translation status written to Status.md", :green
