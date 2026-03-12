import QtQuick
import org.kde.plasma.plasma5support as Plasma5Support

Item {
    id: recentItems

    property var recentDocs: []

    signal itemsUpdated()

    function loadRecentItems() {
        execSource.connectSource("grep -oP 'href=\"\\K[^\"]+' ~/.local/share/recently-used.xbel 2>/dev/null | head -10")
    }

    function clearRecentItems() {
        recentDocs = []
        itemsUpdated()
        execSource.connectSource("rm -f ~/.local/share/recently-used.xbel")
    }

    function parseRecentItems(output) {
        const docs = []
        const lines = output.split("\n")

        for (const line of lines) {
            if (!line.trim() || docs.length >= 10) {
                continue
            }

            const url = line.trim()
            if (!url.startsWith("file://")) {
                continue
            }

            const path = url.slice(7)
            const name = decodeURIComponent(path.split("/").pop() || "")
            const extension = name.includes(".") ? name.split(".").pop().toLowerCase() : ""

            docs.push({
                "name": name,
                "url": url,
                "icon": iconForExtension(extension)
            })
        }

        recentDocs = docs
        itemsUpdated()
    }

    function iconForExtension(extension) {
        const iconMap = {
            "pdf": "application-pdf",
            "doc": "application-msword",
            "docx": "application-vnd.openxmlformats-officedocument.wordprocessingml.document",
            "odt": "application-vnd.oasis.opendocument.text",
            "txt": "text-plain",
            "md": "text-markdown",
            "png": "image-png",
            "jpg": "image-jpeg",
            "jpeg": "image-jpeg",
            "gif": "image-gif",
            "svg": "image-svg+xml",
            "mp3": "audio-mpeg",
            "mp4": "video-mp4",
            "mkv": "video-x-matroska",
            "zip": "application-zip",
            "tar": "application-x-tar",
            "gz": "application-gzip"
        }

        return iconMap[extension] || "text-x-generic"
    }

    Plasma5Support.DataSource {
        id: execSource
        engine: "executable"
        connectedSources: []

        onNewData: function(sourceName, data) {
            if (sourceName.includes("recently-used.xbel")) {
                recentItems.parseRecentItems(data.stdout || "")
            }

            disconnectSource(sourceName)
        }
    }

    Component.onCompleted: loadRecentItems()
}
