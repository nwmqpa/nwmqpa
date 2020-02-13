EAPI=5
inherit font

DESCRIPTION="JetBrains Mono – the free and open-source typeface for developers "
HOMEPAGE="https://jetbrains.com/mono"
SRC_URI="https://download.jetbrains.com/fonts/JetBrainsMono-1.0.0.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
DEPEND="app-arch/unzip"

S=${WORKDIR}
FONT_SUFFIX="ttf"
