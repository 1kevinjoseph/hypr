#!/bin/bash
# session-notify.sh
# Place at ~/.config/hypr/scripts/session-notify.sh
# chmod +x it, then call with:
#   exec-once = ~/.config/hypr/scripts/session-notify.sh login
#   bind = $mod, M, exec, ~/.config/hypr/scripts/session-notify.sh logout

STATE_FILE="$HOME/.local/share/hypr-session-state"
FIRST_LOGIN_FLAG="$HOME/.local/share/hypr-first-login"
MODE="${1:-login}"

mkdir -p "$(dirname "$STATE_FILE")"

# ── helpers ──────────────────────────────────────────────────────────────────

get_hour() { date +%H; }

time_greeting() {
    local h; h=$(get_hour)
    if   (( h >= 5  && h < 12 )); then echo "Good morning"
    elif (( h >= 12 && h < 17 )); then echo "Good afternoon"
    elif (( h >= 17 && h < 21 )); then echo "Good evening"
    else echo "Burning the midnight oil"
    fi
}

user_name() {
    # Prefer full name from passwd, fall back to $USER
    getent passwd "$USER" | cut -d: -f5 | cut -d, -f1 | grep -v '^$' || echo "$USER"
}

last_logout_str() {
    # Read timestamp written at logout
    if [[ -f "$STATE_FILE" ]]; then
        cat "$STATE_FILE"
    else
        echo ""
    fi
}

save_logout_time() {
    date "+%A %d %b at %H:%M" > "$STATE_FILE"
}

random_from() {
    # pick a random line from the arguments
    local arr=("$@")
    echo "${arr[RANDOM % ${#arr[@]}]}"
}

# ── login messages ────────────────────────────────────────────────────────────

first_login_messages=(
    "Welcome to your new setup. Let's make something great."
    "First boot. Everything is exactly as you left it — unbroken."
    "Fresh start. The terminal is yours."
    "Welcome. Config files await. You know what to do."
    "Hello for the first time. Make yourself at home."
)

welcome_back_messages=(
    "Welcome back."
    "Good to see you again. The dots are still configured."
    "You're back. Nothing broke while you were gone."
    "Welcome back. The terminal missed you."
    "Back again. Let's get to work."
    
)

# ── logout messages ───────────────────────────────────────────────────────────

logout_messages=(
    "Session ended. Rest well."
    "Logging out. See you next time."
    "Goodbye. Your configs are safe."
    "Shutting down the session. Take care."
    "Until next time."
)
# ── unlock messages  ───────────────────────────────
unlock_messages=(
    "Welcome back. Everything is still running."
    "Unlocked. Carrying on."
    "Back at the terminal."
    "You're back. Nothing changed."
)

# ── main ──────────────────────────────────────────────────────────────────────

NAME=$(user_name)
GREETING=$(time_greeting)

if [[ "$MODE" == "logout" ]]; then
    save_logout_time
    MSG=$(random_from "${logout_messages[@]}")
    notify-send -t 4000 -u low \
        -h string:x-dunst-stack-tag:session \
        "Goodbye, $NAME" "$MSG"
    exit 0
fi
# ── unlock ─────────────────────────────────────
if [[ "$MODE" == "unlock" ]]; then
    MSG=$(random_from "${unlock_messages[@]}")
    notify-send -t 3000 -u low \
        -h string:x-dunst-stack-tag:session \
        "$GREETING, $NAME." "$MSG"
    exit 0
fi

# ── login ─────────────────────────────────────────────────────────────────────

LAST=$(last_logout_str)

if [[ ! -f "$FIRST_LOGIN_FLAG" ]]; then
    # Very first ever login
    touch "$FIRST_LOGIN_FLAG"
    MSG=$(random_from "${first_login_messages[@]}")
    TITLE="$GREETING, $NAME."
    BODY="$MSG"
else
    MSG=$(random_from "${welcome_back_messages[@]}")
    TITLE="$GREETING, $NAME."
    if [[ -n "$LAST" ]]; then
        BODY="$MSG\nLast session ended: $LAST"
    else
        BODY="$MSG"
    fi
fi

# Small delay so dunst is up before we send
sleep 1.5

notify-send -t 6000 -u low \
    -h string:x-dunst-stack-tag:session \
    "$TITLE" "$BODY"