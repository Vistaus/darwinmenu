require 'fileutils'
require 'shellwords'
require_relative 'color'

PLASMA_MO_NAME = 'plasma_applet_org.latgardi.darwinmenu.mo'

PROJECT_ROOT = File.expand_path('../..', __dir__)
PO_DIR       = File.expand_path('..', __dir__)
MO_BASE      = File.join(PROJECT_ROOT, 'contents', 'locale')

def mo_readable?(mo_path)
    output = `msgunfmt #{mo_path} 2>&1`
    output.include?("msgid") && !output.include?("invalid multibyte sequence")
end

def compile_po(po_path)
    lang    = File.basename(po_path, '.po')
    mo_path = File.join(MO_BASE, lang, 'LC_MESSAGES', PLASMA_MO_NAME)
    FileUtils.mkdir_p(File.dirname(mo_path))

    result = system("msgfmt #{po_path.shellescape} -o #{mo_path.shellescape}")
    if result && File.exist?(mo_path)
        if mo_readable?(mo_path)
            Color.echo "[build] Compiled #{po_path} → #{mo_path}", :green
        else
            Color.echo "[build] Invalid .mo file: #{mo_path} — removing", :red
            File.delete(mo_path)
        end
    else
        Color.echo "[build] Failed to compile #{po_path}", :red
    end
end

Dir.glob(File.join(PO_DIR, '*.po')).each do |po_file|
    compile_po(po_file)
end
