# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg-utils

MY_EXE="setup_unreal_tournament_2004_1.0_(18947).exe"

DESCRIPTION="Unreal Tournament 2004 - This is the data portion of UT2004"
HOMEPAGE="https://liandri.beyondunreal.com/Unreal_Tournament_2004"
SRC_URI="${MY_EXE} ${MY_EXE%.exe}-1.bin"

LICENSE="ut2003"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="bindist fetch"

BDEPEND="app-arch/innoextract"

PDEPEND=">=games-fps/ut2004-3369.3-r2"
RDEPEND="!games-fps/ut2004-ded"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  https://gog.com/"
	einfo "and move it to your distfiles directory."
}

src_unpack() {
	innoextract --extract --silent --exclude-temp "${DISTDIR}/${MY_EXE}" || die
}

src_prepare() {
	default

	# Fix capitalization of file names
	mv System/A{l,L}Audio.kot || die
	mv System/Bonus{p,P}ack.itt || die
	mv System/{B,b}onuspack.det || die
	mv System/{B,b}onuspack.est || die
	mv System/{B,b}onuspack.frt || die
	mv System/Skaarj{p,P}ack.det || die
	mv System/Skaarj{p,P}ack.est || die
	mv System/Skaarj{p,P}ack.frt || die
	mv System/Skaarj{p,P}ack.itt || die
	mv System/Skaarj{p,P}ack.kot || die
	mv System/UT2{K,k}4Assault.det || die
	mv System/UT2{K,k}4Assault.est || die
	mv System/UT2{K,k}4Assault.frt || die
	mv System/UT2{K,k}4Assault.itt || die
	mv System/UT2{K,k}4AssaultFull.det || die
	mv System/UT2{K,k}4AssaultFull.est || die
	mv System/UT2{K,k}4AssaultFull.frt || die
	mv System/UT2{K,k}4AssaultFull.itt || die
	mv System/{x,X}Admin.kot || die
	mv System/{x,X}Pickups.det || die
	mv System/{x,X}Pickups.est || die
	mv System/{x,X}Pickups.frt || die
	mv System/{x,X}Pickups.itt || die
	mv System/{x,X}WebAdmin.det || die
	mv System/{x,X}WebAdmin.est || die
	mv System/{x,X}WebAdmin.frt || die
	mv System/{x,X}WebAdmin.itt || die
	mv Textures/2{k,K}4Fonts_kot.utx || die
}

src_install() {
	local Ddir="${ED}"/opt/ut2004

	dodir /opt/ut2004
	mv {Animations,ForceFeedback,Help,KarmaData,Manual,Maps,Music,Sounds,Speech,StaticMeshes,System,Textures,Web} "${Ddir}"/ || die

	insinto /opt/ut2004/Benchmark
	doins -r app/Benchmark/Stuff
	insinto /opt/ut2004/System
	doins __support/app/System/{Default,DefUnrealEd,DefUser}.ini

	newicon "${Ddir}"/System/Unreal.ico ut2004.ico

	# Create empty files in Benchmark
	keepdir /opt/ut2004/Benchmark/{CSVs,Logs,Results}

	# Remove unneccessary files
	rm -f "${Ddir}"/*.{bat,exe,EXE,int} || die
	rm -f "${Ddir}"/Help/{.DS_Store,SAPI-EULA.txt} || die
	rm -f "${Ddir}"/Manual/*.exe || die
	rm -rf "${Ddir}"/Speech/Redist || die
	rm -f "${Ddir}"/System/*.{bat,dll,exe,tar} || die
	rm -f "${Ddir}"/System/{{License,Manifest}.smt,{ucc,StdOut}.log} || die
	rm -f "${Ddir}"/System/{User,UT2004}.ini || die

	# Remove file collisions with ut2004-3369-r4
	rm -f "${Ddir}"/Animations/ONSNewTank-A.ukx || die
	rm -f "${Ddir}"/Help/UT2004Logo.bmp || die
	rm -f "${Ddir}"/System/{ALAudio.kot,AS-{Convoy,FallenCity,Glacier}.kot,AS-{Convoy,FallenCity,Glacier,Junkyard,Mothership,RobotFactory}.int,bonuspack.{det,est,frt},BonusPack.{int,itt,u},BR-Serenity.int} || die
	rm -f "${Ddir}"/System/CTF-{AbsoluteZero,BridgeOfFate,DE-ElecFields,DoubleDammage,January,LostFaith}.int || die
	rm -f "${Ddir}"/System/DM-{1on1-Albatross,1on1-Desolation,1on1-Mixer,Corrugation,IronDeity,JunkYard}.int || die
	rm -f "${Ddir}"/System/{DOM-Atlantis.int,OnslaughtBP.{kot,u,ucl},OnslaughtFull.int} || die
	rm -f "${Ddir}"/System/{Build.ini,CacheRecords.ucl,Core.{est,frt,kot,int,itt,u},CTF-January.kot,D3DDrv.kot,DM-1on1-Squader.kot} || die
	rm -f "${Ddir}"/System/{Editor,Engine,Gameplay,GamePlay,UnrealGame,UT2k4Assault,XInterface,XPickups,xVoting,XVoting,XWeapons,XWebAdmin}.{det,est,frt,int,itt,u} || die
	rm -f "${Ddir}"/System/{Fire.u,IpDrv.u,License.int,ONS-ArcticStronghold.kot} || die
	rm -f "${Ddir}"/System/{OnslaughtFull,onslaughtfull,UT2k4AssaultFull}.{det,est,frt,itt,u} || die
	rm -f "${Ddir}"/System/{GUI2K4,Onslaught,skaarjpack,SkaarjPack,XGame}.{det,est,frt,int,itt,kot,u} || die
	rm -f "${Ddir}"/System/{Setup,Window}.{det,est,frt,int,itt,kot} || die
	rm -f "${Ddir}"/System/XPlayers.{det,est,frt,int,itt} || die
	rm -f "${Ddir}"/System/{UnrealEd.u,UTClassic.u,UTV2004c.u,UTV2004s.u,UWeb.u,Vehicles.kot,Vehicles.u,Xweapons.itt,UT2K4AssaultFull.int,UTV2004.kot,UTV2004s.kot} || die
	rm -f "${Ddir}"/System/{XAdmin.kot,XAdmin.u,XMaps.det,XMaps.est} || die
	rm -f "${Ddir}"/Textures/jwfasterfiles.utx || die
	rm -f "${Ddir}"/Web/ServerAdmin/{admins_home.htm,current_bots.htm,ut2003.css,current_bots_species_group.inc} || die
	rm -f "${Ddir}"/Web/ServerAdmin/ClassicUT/current_bots.htm || die
	rm -f "${Ddir}"/Web/ServerAdmin/UnrealAdminPage/{adminsframe.htm,admins_home.htm,admins_menu.htm,current_bots.htm,currentframe.htm,current_menu.htm} || die
	rm -f "${Ddir}"/Web/ServerAdmin/UnrealAdminPage/{defaultsframe.htm,defaults_menu.htm,footer.inc,mainmenu.htm,mainmenu_itemd.inc,rootframe.htm,UnrealAdminPage.css} || die
	rm -f "${Ddir}"/Web/ServerAdmin/UT2K3Stats/{admins_home.htm,current_bots.htm,ut2003stats.css} || die

	# Remove file collisions with ut2004-bonuspack-ece
	rm -f "${Ddir}"/Animations/{MechaSkaarjAnims,MetalGuardAnim,NecrisAnim,ONSBPAnimations}.ukx || die
	rm -f "${Ddir}"/Help/BonusPackReadme.txt || die
	rm -f "${Ddir}"/Maps/ONS-{Adara,IslandHop,Tricky,Urban}.ut2 || die
	rm -f "${Ddir}"/Sounds/{CicadaSnds,DistantBooms,ONSBPSounds}.uax || die
	rm -f "${Ddir}"/StaticMeshes/{BenMesh02,BenTropicalSM01,HourAdara,ONS-BPJW1,PC_UrbanStatic}.usx || die
	rm -f "${Ddir}"/System/{ONS-Adara.int,ONS-IslandHop.int,ONS-Tricky.int,ONS-Urban.int,OnslaughtBP.int,xaplayersl3.upl} || die
	rm -f "${Ddir}"/Textures/{AW-2k4XP,BenTex02,BenTropical01,BonusParticles,CicadaTex,Construction_S}.utx || die
	rm -f "${Ddir}"/Textures/{HourAdaraTexor,ONSBPTextures,ONSBP_DestroyedVehicles,PC_UrbanTex,UT2004ECEPlayerSkins}.utx || die

	# Remove file collisions with ut2004-bonuspack-mega
	rm -f "${Ddir}"/Help/MegapackReadme.txt || die
	rm -f "${Ddir}"/Maps/{AS-BP2-Acatana,AS-BP2-Jumpship,AS-BP2-Outback,AS-BP2-SubRosa,AS-BP2-Thrust}.ut2 || die
	rm -f "${Ddir}"/Maps/{CTF-BP2-Concentrate,CTF-BP2-Pistola,DM-BP2-Calandras,DM-BP2-GoopGod}.ut2 || die
	rm -f "${Ddir}"/Music/APubWithNoBeer.ogg || die
	rm -f "${Ddir}"/Sounds/A_Announcer_BP2.uax || die
	rm -f "${Ddir}"/StaticMeshes/{JumpShipObjects,Ty_RocketSMeshes}.usx || die
	rm -f "${Ddir}"/System/{AssaultBP.u,Manifest.in{i,t},Packages.md5} || die
	rm -f "${Ddir}"/Textures/{JumpShipTextures,T_Epic2k4BP2,Ty_RocketTextures}.utx || die
}

pkg_postinst() {
	xdg_icon_cache_update

	elog "This is only the data portion of the game. To play UT2004,"
	elog "you still need to install games-fps/ut2004."
}

pkg_postrm() {
	xdg_icon_cache_update
}
