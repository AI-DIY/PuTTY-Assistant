/*
 * Native Windows AI side panel for PuTTY AI.
 */

#ifndef PUTTY_WINDOWS_AI_H
#define PUTTY_WINDOWS_AI_H

#include <windows.h>

typedef struct WinGuiSeat WinGuiSeat;
typedef struct AiPanel AiPanel;

#define WM_PUTTY_AI_RESPONSE (WM_APP + 40)
#define WM_PUTTY_AI_STREAM (WM_APP + 41)
#define WM_PUTTY_AI_QUERY_DEFAULT_WIDTH (WM_APP + 42)
#define WM_PUTTY_AI_QUERY_SELECTED_COLOUR (WM_APP + 43)
#define WM_PUTTY_AI_QUERY_SELECTED_STYLE (WM_APP + 44)
#define WM_PUTTY_AI_QUERY_SELECTED_BACK_COLOUR (WM_APP + 45)
#define WM_PUTTY_AI_QUERY_LAST_RESPONSE_COLOUR (WM_APP + 46)
#define WM_PUTTY_AI_QUERY_SESSION_COUNT (WM_APP + 47)
#define WM_PUTTY_AI_QUERY_SESSION_WINDOW (WM_APP + 48)
#define WM_PUTTY_AI_QUERY_CANDIDATE_RANGE (WM_APP + 49)
#define WM_PUTTY_AI_QUERY_CANDIDATE_POINT (WM_APP + 50)
#define WM_PUTTY_AI_QUERY_LAST_ACTIVATED_SESSION (WM_APP + 51)

#define PUTTY_AI_STYLE_BOLD 0x0001
#define PUTTY_AI_STYLE_ITALIC 0x0002
#define PUTTY_AI_STYLE_UNDERLINE 0x0004
#define PUTTY_AI_STYLE_STRIKEOUT 0x0008
#define PUTTY_AI_STYLE_CODE 0x0010
#define PUTTY_AI_STYLE_ROLE_HEADER 0x0020
#define PUTTY_AI_STYLE_HEIGHT_SHIFT 8

int ai_panel_default_width(void);
int ai_panel_terminal_top(void);
AiPanel *ai_panel_create(WinGuiSeat *wgs);
void ai_panel_destroy(AiPanel *panel);
void ai_panel_set_current_user(AiPanel *panel, const char *username);
int ai_panel_width(const AiPanel *panel);
void ai_panel_layout(AiPanel *panel);
bool ai_panel_handle_command(
    AiPanel *panel, unsigned id, unsigned notification, HWND control);
bool ai_panel_handle_message(
    AiPanel *panel, UINT message, WPARAM wParam, LPARAM lParam,
    LRESULT *result);

#endif
