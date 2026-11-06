#! /usr/bin/env bash

SRC_DIR="$(cd $(dirname $0) && pwd)"
ROOT_UID=0

THEME_NAME=Fluent
THEME_VARIANTS=('' '-purple' '-pink' '-red' '-orange' '-yellow' '-green' '-grey' '-teal')
COLOR_VARIANTS=('' '-light' '-dark')

round=
solid=
no_sddm=

# Destination directory
if [ "$UID" -eq "$ROOT_UID" ]; then
  AURORAE_DIR="/usr/share/aurorae/themes"
  SCHEMES_DIR="/usr/share/color-schemes"
  PLASMA_DIR="/usr/share/plasma/desktoptheme"
  LOOKFEEL_DIR="/usr/share/plasma/look-and-feel"
  KVANTUM_DIR="/usr/share/Kvantum"
  WALLPAPER_DIR="/usr/share/wallpapers"
  PLASMOIDS_DIR="/usr/share/plasma/plasmoids"
  LAYOUT_DIR="/usr/share/plasma/layout-templates"
  SDDM_DIR="/usr/share/sddm/themes"
else
  AURORAE_DIR="$HOME/.local/share/aurorae/themes"
  SCHEMES_DIR="$HOME/.local/share/color-schemes"
  PLASMA_DIR="$HOME/.local/share/plasma/desktoptheme"
  LOOKFEEL_DIR="$HOME/.local/share/plasma/look-and-feel"
  KVANTUM_DIR="$HOME/.config/Kvantum"
  WALLPAPER_DIR="$HOME/.local/share/wallpapers"
  PLASMOIDS_DIR="$HOME/.local/share/plasma/plasmoids"
  LAYOUT_DIR="$HOME/.local/share/plasma/layout-templates"
fi

# COLORS
CDEF=" \033[0m"                                     # default color
CCIN=" \033[0;36m"                                  # info color
CGSC=" \033[0;32m"                                  # success color
CRER=" \033[0;31m"                                  # error color
CWAR=" \033[0;33m"                                  # warning color
b_CDEF=" \033[1;37m"                                # bold default color
b_CCIN=" \033[1;36m"                                # bold info color
b_CGSC=" \033[1;32m"                                # bold success color
b_CRER=" \033[1;31m"                                # bold error color
b_CWAR=" \033[1;33m"                                # bold warning color

# Echo like ... with flag type and display message colors
prompt () {
  case ${1} in
    "-s"|"--success")
      echo -e "${b_CGSC}${@/-s/}${CDEF}";;    # print success message
    "-e"|"--error")
      echo -e "${b_CRER}${@/-e/}${CDEF}";;    # print error message
    "-w"|"--warning")
      echo -e "${b_CWAR}${@/-w/}${CDEF}";;    # print warning message
    "-i"|"--info")
      echo -e "${b_CCIN}${@/-i/}${CDEF}";;    # print info message
    *)
    echo -e "$@"
    ;;
  esac
}

usage() {
  cat << EOF
Usage: $0 [OPTION]...

OPTIONS:
  -t, --theme VARIANT     Specify theme color variant(s) [default|purple|pink|red|orange|yellow|green|grey|teal|all] (Default: blue)
  -c, --color VARIANT     Specify color variant(s) [standard|light|dark] (Default: All variants)
  --round VARIANT         Specify round variant
  --solid VARIANT         Specify solid variant
  --no-sddm               Skip installing the SDDM lock-screen theme
  -h, --help              Show help
EOF
}

[[ ! -d ${AURORAE_DIR} ]] && mkdir -p ${AURORAE_DIR}
[[ ! -d ${SCHEMES_DIR} ]] && mkdir -p ${SCHEMES_DIR}
[[ ! -d ${PLASMA_DIR} ]] && mkdir -p ${PLASMA_DIR}
[[ ! -d ${LOOKFEEL_DIR} ]] && mkdir -p ${LOOKFEEL_DIR}
[[ ! -d ${KVANTUM_DIR} ]] && mkdir -p ${KVANTUM_DIR}
[[ ! -d ${WALLPAPER_DIR} ]] && mkdir -p ${WALLPAPER_DIR}
[[ ! -d ${PLASMOIDS_DIR} ]] && mkdir -p ${PLASMOIDS_DIR}
[[ ! -d ${LAYOUT_DIR} ]] && mkdir -p ${LAYOUT_DIR}

install() {
  local theme="$1"
  local color="$2"

  case "${theme}" in
    -purple)
      ctheme='Purple'
      ;;
    -pink)
      ctheme='Pink'
      ;;
    -red)
      ctheme='Red'
      ;;
    -orange)
      ctheme='Orange'
      ;;
    -yellow)
      ctheme='Yellow'
      ;;
    -green)
      ctheme='Green'
      ;;
    -grey)
      ctheme='Grey'
      ;;
    -teal)
      ctheme='Teal'
      ;;
    *)
      ctheme=''
      ;;
  esac

  case "${color}" in
    -light)
      ccolor='Light'
      ;;
    -dark)
      ccolor='Dark'
      ;;
    *)
      ccolor=''
      ;;
  esac

  [[ "$color" == '-light' ]] && local ELSE_LIGHT="$color"

  [[ -d ${AURORAE_DIR}/${THEME_NAME}${round}${color}${solid} ]]                               && rm -rf ${AURORAE_DIR}/${THEME_NAME}${round}${color}${solid}
  for d in ${AURORAE_DIR}/${THEME_NAME}${round}${color}{,-normal}; do [[ -d "$d" ]] && rm -rf "$d"; done
  [[ -d ${PLASMA_DIR}/${THEME_NAME}${round}${theme}${color}${solid} ]]                        && rm -rf ${PLASMA_DIR}/${THEME_NAME}${round}${theme}${color}${solid}
  [[ -f ${SCHEMES_DIR}/${THEME_NAME}${ctheme}${ccolor}.colors ]]                              && rm -rf ${SCHEMES_DIR}/${THEME_NAME}${ctheme}${ccolor}.colors
  [[ -d ${LOOKFEEL_DIR}/com.github.vinceliuice.${THEME_NAME}${round}${theme}${color}${solid} ]] && rm -rf ${LOOKFEEL_DIR}/com.github.vinceliuice.${THEME_NAME}${round}${theme}${color}${solid}
  [[ -d ${KVANTUM_DIR}/${THEME_NAME}${round}${theme}${solid} ]]                               && rm -rf ${KVANTUM_DIR}/${THEME_NAME}${round}${theme}${solid}
  [[ -d ${WALLPAPER_DIR}/${THEME_NAME}${theme} ]]                                             && rm -rf ${WALLPAPER_DIR}/${THEME_NAME}${theme}
  [[ -d ${WALLPAPER_DIR}/${THEME_NAME}${round}${color} ]]                                     && rm -rf ${WALLPAPER_DIR}/${THEME_NAME}${round}${color}

  prompt -i "Installing ${THEME_NAME}${round}${theme}${color}..."

  if [[ "$round" == '-round' ]]; then
    cp -r ${SRC_DIR}/aurorae/${THEME_NAME}${round}${color}${solid}                            ${AURORAE_DIR}
    cp -r ${SRC_DIR}/aurorae/${THEME_NAME}${round}${color}-normal                             ${AURORAE_DIR}
  else
    cp -r ${SRC_DIR}/aurorae/${THEME_NAME}${color}                                            ${AURORAE_DIR}
  fi

  cp -r ${SRC_DIR}/wallpaper/${THEME_NAME}${theme}                                            ${WALLPAPER_DIR}

  if [[ "$round" == '-round' ]]; then
    cp -r ${SRC_DIR}/wallpaper/${THEME_NAME}${round}${color}                                  ${WALLPAPER_DIR}
  fi

  mkdir -p                                                                                    ${KVANTUM_DIR}/${THEME_NAME}${round}${theme}${solid}
  cp -r ${SRC_DIR}/Kvantum/${THEME_NAME}${round}${theme}${solid}/*                            ${KVANTUM_DIR}/${THEME_NAME}${round}${theme}${solid}

  if [[ "$color" != '' ]]; then
    cp -r ${SRC_DIR}/color-schemes/${THEME_NAME}${ctheme}${ccolor}.colors                     ${SCHEMES_DIR}
    mkdir -p                                                                                  ${LOOKFEEL_DIR}/com.github.vinceliuice.${THEME_NAME}${round}${theme}${color}${solid}
    cp -r ${SRC_DIR}/plasma/look-and-feel/com.github.vinceliuice.${THEME_NAME}${round}${theme}${color}/* ${LOOKFEEL_DIR}/com.github.vinceliuice.${THEME_NAME}${round}${theme}${color}${solid}

    mkdir -p                                                                                  ${PLASMA_DIR}/${THEME_NAME}${round}${theme}${color}${solid}
    cp -r ${SRC_DIR}/plasma/desktoptheme/${THEME_NAME}${round}/*                              ${PLASMA_DIR}/${THEME_NAME}${round}${theme}${color}${solid}
    cp -r ${SRC_DIR}/plasma/desktoptheme/${THEME_NAME}${round}${ELSE_LIGHT}/dialogs/*.svgz    ${PLASMA_DIR}/${THEME_NAME}${round}${theme}${color}${solid}/dialogs
    cp -r ${SRC_DIR}/plasma/desktoptheme/${THEME_NAME}${round}${ELSE_LIGHT}/widgets/*.svgz    ${PLASMA_DIR}/${THEME_NAME}${round}${theme}${color}${solid}/widgets
    cp -r ${SRC_DIR}/plasma/desktoptheme/${THEME_NAME}${round}${ELSE_LIGHT}/translucent/*     ${PLASMA_DIR}/${THEME_NAME}${round}${theme}${color}${solid}/translucent

    if [[ "$theme" != '' ]]; then
      sed -i "s|defaultWallpaperTheme=${THEME_NAME}|defaultWallpaperTheme=${THEME_NAME}${theme}|" ${PLASMA_DIR}/${THEME_NAME}${round}${theme}${color}${solid}/metadata.desktop
    fi

    cp -r ${SRC_DIR}/color-schemes/${THEME_NAME}${ctheme}${ccolor}.colors                     ${PLASMA_DIR}/${THEME_NAME}${round}${theme}${color}${solid}/colors
  else
    mkdir -p                                                                                  ${PLASMA_DIR}/${THEME_NAME}${round}${solid}
    cp -r ${SRC_DIR}/plasma/desktoptheme/${THEME_NAME}${round}/*                              ${PLASMA_DIR}/${THEME_NAME}${round}${solid}
    mkdir -p                                                                                  ${LOOKFEEL_DIR}/com.github.vinceliuice.${THEME_NAME}${round}${solid}
    cp -r ${SRC_DIR}/plasma/look-and-feel/com.github.vinceliuice.${THEME_NAME}${round}/*      ${LOOKFEEL_DIR}/com.github.vinceliuice.${THEME_NAME}${round}${solid}
  fi

  sed -i "s|Name=${THEME_NAME}${round}|Name=${THEME_NAME}${round}${theme}${color}${solid}|"   ${PLASMA_DIR}/${THEME_NAME}${round}${theme}${color}${solid}/metadata.desktop

  if [[ "$solid" == '-solid' ]]; then
    # plasma theme
    cp -r ${SRC_DIR}/plasma/desktoptheme/${THEME_NAME}${round}${ELSE_LIGHT}${solid}/*         ${PLASMA_DIR}/${THEME_NAME}${round}${theme}${color}${solid}
    sed -i "s|enabled=true|enabled=false|"                                                    ${PLASMA_DIR}/${THEME_NAME}${round}${theme}${color}${solid}/metadata.desktop
    rm -rf ${PLASMA_DIR}/${THEME_NAME}${round}${theme}${color}${solid}/{solid,translucent}
    # global theme
    sed -i "s|Name=${THEME_NAME}${round}${theme}${color}|Name=${THEME_NAME}${round}${theme}${color}${solid}|" ${LOOKFEEL_DIR}/com.github.vinceliuice.${THEME_NAME}${round}${theme}${color}${solid}/metadata.desktop
    sed -i "s|Name=com.github.vinceliuice.${THEME_NAME}${round}${theme}${color}|Name=com.github.vinceliuice.${THEME_NAME}${round}${theme}${color}${solid}|" ${LOOKFEEL_DIR}/com.github.vinceliuice.${THEME_NAME}${round}${theme}${color}${solid}/metadata.desktop
    # Plasma 6 prefers metadata.json over metadata.desktop for KPackage Id/Name; mirror the rewrites so the solid package isn't shadowed by the non-solid one.
    if [[ -f ${LOOKFEEL_DIR}/com.github.vinceliuice.${THEME_NAME}${round}${theme}${color}${solid}/metadata.json ]]; then
      sed -i \
        -e "s|\"Id\": \"com.github.vinceliuice.${THEME_NAME}${round}${theme}${color}\"|\"Id\": \"com.github.vinceliuice.${THEME_NAME}${round}${theme}${color}${solid}\"|" \
        -e "s|\"Name\": \"${THEME_NAME}${round}${theme}${color}\"|\"Name\": \"${THEME_NAME}${round}${theme}${color}${solid}\"|" \
        ${LOOKFEEL_DIR}/com.github.vinceliuice.${THEME_NAME}${round}${theme}${color}${solid}/metadata.json
    fi
    if [[ "$round" == '-round' ]]; then
      sed -i "s|theme=__aurorae__svg__${THEME_NAME}${round}${color}|theme=__aurorae__svg__${THEME_NAME}${round}${color}${solid}|" ${LOOKFEEL_DIR}/com.github.vinceliuice.${THEME_NAME}${round}${theme}${color}${solid}/contents/defaults
    fi
    sed -i "s|name=${THEME_NAME}${round}${theme}${color}|name=${THEME_NAME}${round}${theme}${color}${solid}|" ${LOOKFEEL_DIR}/com.github.vinceliuice.${THEME_NAME}${round}${theme}${color}${solid}/contents/defaults
  fi

  if [[ "$round" == '-round' ]]; then
    sed -i "s|defaultWallpaperTheme=${THEME_NAME}|defaultWallpaperTheme=${THEME_NAME}${round}${color}|" ${PLASMA_DIR}/${THEME_NAME}${round}${theme}${color}${solid}/metadata.desktop
  fi
}

install_common() {
  cp -r ${SRC_DIR}/plasma/plasmoids/*                                                         ${PLASMOIDS_DIR}
  cp -r ${SRC_DIR}/plasma/layout-templates/*                                                  ${LAYOUT_DIR}
  cp -r ${SRC_DIR}/Kvantum/${THEME_NAME}-round${solid}                                        ${KVANTUM_DIR}
}

# Resolve the home directory of the user this install is for. Under sudo $HOME
# is /root, so user-scoped artifacts (Xresources, ~/.cache) need SUDO_USER's home.
target_home() {
  if [[ "$UID" -eq "$ROOT_UID" && -n "${SUDO_USER:-}" && "${SUDO_USER}" != "root" ]]; then
    getent passwd "${SUDO_USER}" | cut -d: -f6
  else
    echo "${HOME}"
  fi
}

install_xresources() {
  local home
  home="$(target_home)"
  [[ -z "${home}" || ! -d "${home}" ]] && return 0
  cp -rf "${SRC_DIR}/configs/Xresources" "${home}/.Xresources"
}

# Rebuild Plasma's per-user service + theme caches so newly-installed look-and-feel
# packages, plasmoids, layout templates, and SVG themes are discovered without a logout.
refresh_caches() {
  local home run=()
  home="$(target_home)"
  [[ -z "${home}" || ! -d "${home}" ]] && return 0
  if [[ "$UID" -eq "$ROOT_UID" && -n "${SUDO_USER:-}" && "${SUDO_USER}" != "root" ]]; then
    run=(sudo -u "${SUDO_USER}")
  fi
  prompt -i "Refreshing Plasma caches..."
  rm -rf "${home}"/.cache/plasma_theme_*.kcache 2>/dev/null
  rm -rf "${home}"/.cache/ksvg-elements 2>/dev/null
  if command -v kbuildsycoca6 >/dev/null 2>&1; then
    "${run[@]}" kbuildsycoca6 --noincremental 2>/dev/null || true
  elif command -v kbuildsycoca5 >/dev/null 2>&1; then
    "${run[@]}" kbuildsycoca5 --noincremental 2>/dev/null || true
  fi
}

# Pick the SDDM background matching the installed variant, mirroring upstream's
# sddm/install.sh (background${variant}.png). Only one SDDM theme dir is installed,
# so --round wins (no round+color backgrounds exist), then the first -t color.
sddm_background_name() {
  local variant=''
  if [[ "${round}" == '-round' ]]; then
    variant='-round'
  elif [[ -n "${themes[0]:-}" ]]; then
    variant="${themes[0]}"
  fi

  if [[ -n "${variant}" && ! -f "${SRC_DIR}/sddm/backgrounds/background${variant}.png" ]]; then
    prompt -w "No SDDM background for '${variant#-}', using the default one." >&2
    variant=''
  fi

  echo "background${variant}.png"
}

install_sddm() {
  [[ "${no_sddm}" == "1" ]] && return 0

  if [[ "$UID" -ne "$ROOT_UID" ]]; then
    prompt -w "Skipping SDDM theme (needs root). Re-run with sudo to install it."
    return 0
  fi

  local sddm_variant
  if plasmashell --version 2>/dev/null | grep -q '^plasmashell 5\.'; then
    sddm_variant='Fluent-5.0'
  else
    sddm_variant='Fluent-6.0'
  fi

  prompt -i "Installing SDDM theme (${sddm_variant})..."
  [[ -d "${SDDM_DIR}/Fluent" ]] && rm -rf "${SDDM_DIR}/Fluent"
  mkdir -p "${SDDM_DIR}"
  cp -r "${SRC_DIR}/sddm/${sddm_variant}" "${SDDM_DIR}/Fluent"
  cp -r "${SRC_DIR}/sddm/assets" "${SDDM_DIR}/Fluent/assets"
  cp "${SRC_DIR}/sddm/preview.png" "${SDDM_DIR}/Fluent/preview.png"
  cp "${SRC_DIR}/sddm/backgrounds/$(sddm_background_name)" "${SDDM_DIR}/Fluent/background.png"
  mkdir -p "${SDDM_DIR}/Fluent/faces"
}

while [[ "$#" -gt 0 ]]; do
  case "${1:-}" in
    --round)
      round='-round'
      prompt -i "Install rounded version."
      shift
      ;;
    --solid)
      solid='-solid'
      prompt -i "Install solid version."
      shift
      ;;
    --no-sddm)
      no_sddm='1'
      shift
      ;;
    -t|--theme)
      shift
      for theme in "$@"; do
        case "$theme" in
          default)
            themes+=("${THEME_VARIANTS[0]}")
            shift
            ;;
          purple)
            themes+=("${THEME_VARIANTS[1]}")
            shift
            ;;
          pink)
            themes+=("${THEME_VARIANTS[2]}")
            shift
            ;;
          red)
            themes+=("${THEME_VARIANTS[3]}")
            shift
            ;;
          orange)
            themes+=("${THEME_VARIANTS[4]}")
            shift
            ;;
          yellow)
            themes+=("${THEME_VARIANTS[5]}")
            shift
            ;;
          green)
            themes+=("${THEME_VARIANTS[6]}")
            shift
            ;;
          grey)
            themes+=("${THEME_VARIANTS[7]}")
            shift
            ;;
          teal)
            themes+=("${THEME_VARIANTS[8]}")
            shift
            ;;
          all)
            themes+=("${THEME_VARIANTS[@]}")
            shift
            ;;
          -*)
            break
            ;;
          *)
            prompt -e "ERROR: Unrecognized theme variant '$1'."
            prompt -i "Try '$0 --help' for more information."
            exit 1
            ;;
        esac
        prompt -w "${theme} version"
      done
      ;;
    -c|--color)
      shift
      for variant in "$@"; do
        case "$variant" in
          standard)
            colors+=("${COLOR_VARIANTS[0]}")
            shift
            ;;
          light)
            colors+=("${COLOR_VARIANTS[1]}")
            shift
            ;;
          dark)
            colors+=("${COLOR_VARIANTS[2]}")
            shift
            ;;
          -*)
            break
            ;;
          *)
            prompt -e "ERROR: Unrecognized color variant '$1'."
            prompt -i "Try '$0 --help' for more information."
            exit 1
            ;;
        esac
      done
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      prompt -e "ERROR: Unrecognized installation option '$1'."
      prompt -i "Try '$0 --help' for more information."
      exit 1
      ;;
  esac
done

if [[ "${#themes[@]}" -eq 0 ]] ; then
  themes=("${THEME_VARIANTS[0]}")
fi

if [[ "${#colors[@]}" -eq 0 ]] ; then
  colors=("${COLOR_VARIANTS[@]}")
fi

for theme in "${themes[@]}"; do
  for color in "${colors[@]}"; do
    install "$theme" "$color"
  done
done

install_common
install_xresources
install_sddm
refresh_caches

prompt -s "Install finished..."
