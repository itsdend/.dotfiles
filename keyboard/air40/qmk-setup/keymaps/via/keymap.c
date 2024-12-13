/* Copyright 2022 Dennis Kruyt (dennis@kruyt.org)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include QMK_KEYBOARD_H

enum unicode_names {
    CH_SMALL,
    CH_BIG,
    CCH_SMALL,
    CCH_BIG,
    SH_SMALL,
    SH_BIG,
    DJ_SMALL,
    DJ_BIG,
    ZH_SMALL,
    ZH_BIG,
};

const uint32_t PROGMEM unicode_map[] = {
    [CH_SMALL]  = 0x0107,  // ‽
    [CH_BIG] = 0x0106,  // ⸮
    [CCH_SMALL]  = 0x010D, // 🐍
    [CCH_BIG] = 0x010C,
    [SH_SMALL] = 0x0161,
    [SH_BIG] = 0x0160,
    [DJ_SMALL] = 0x0111,
    [DJ_BIG] = 0x0110,
    [ZH_SMALL] = 0x017E,
    [ZH_BIG] = 0x017D
                      //
};

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    [0] = LAYOUT_ortho_4x12(
        KC_ESC,  KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,    KC_Y,    KC_U,    KC_I,    KC_O,    KC_P,    KC_BSPC,
        OSM(MOD_LCTL),  KC_A,    KC_S,    KC_D,    KC_F,    KC_G,    KC_H,    KC_J,    KC_K,    KC_L,    KC_SCLN, KC_ENT,
        OSL(2), KC_Z, KC_X, KC_C, KC_V, KC_B, KC_N, KC_M, KC_COMM, KC_DOT, KC_SLSH, OSL(3),
        OSM(MOD_LGUI), LCA(KC_TAB), MO(5), KC_TAB, KC_SPC, OSM(MOD_LALT), OSL(1), OSM(MOD_LSFT | MOD_RSFT), OSL(3), MO(5), KC_APP, MO(4)
    ),
    [1] = LAYOUT_ortho_4x12(
      KC_TRNS, KC_TRNS, S(KC_4), KC_GRV, KC_BSLS, S(KC_6), KC_EQL, S(KC_LBRC), S(KC_RBRC), S(KC_5), S(KC_1), KC_TRNS,
      KC_TRNS, S(KC_2), KC_TRNS, KC_TRNS, S(KC_QUOT), S(KC_7), S(KC_MINS), S(KC_9), S(KC_0), KC_MINS, S(KC_EQL), KC_TRNS,
      KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_QUOT, S(KC_3), S(KC_GRV), KC_LBRC, KC_RBRC, S(KC_8), S(KC_BSLS), KC_TRNS,
      KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS
    ),
    [2] = LAYOUT_ortho_4x12(
      KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_7, KC_8, KC_9, KC_TRNS, KC_TRNS,
      KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_4, KC_5, KC_6, KC_TRNS, KC_TRNS,
      KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_1, KC_2, KC_3, KC_TRNS, KC_TRNS,
      KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_0, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS
    ),
    [3] = LAYOUT_ortho_4x12(
      KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,
      KC_TRNS, KC_TRNS, UP(SH_SMALL, SH_BIG), UP(DJ_SMALL, DJ_BIG), KC_TRNS, KC_TRNS, KC_LEFT, KC_DOWN, KC_UP, KC_RGHT, KC_TRNS, KC_TRNS,
      KC_TRNS, UP(ZH_SMALL, ZH_BIG), UP(CCH_SMALL, CCH_BIG), UP(CH_SMALL, CH_BIG), KC_TRNS, KC_TRNS, KC_TRNS, RCS(KC_U), KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,
      KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS
    ),
     [4] = LAYOUT_ortho_4x12(
      KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_F7, KC_F8, KC_F9, KC_TRNS, KC_TRNS,
      KC_TRNS, RGB_VAI, RGB_MOD, RGB_HUI, RGB_SAI, RGB_SPI, KC_TRNS, KC_F4, KC_F5, KC_F6, KC_TRNS, KC_TRNS,
      KC_TRNS, RGB_VAD, RGB_RMOD, RGB_HUD, RGB_SAD, RGB_SPD, KC_TRNS, KC_F1, KC_F2, KC_F3, KC_TRNS, KC_TRNS,
      KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_F10, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS
    ), [5] = LAYOUT_ortho_4x12(
      KC_SLEP, KC_TRNS, KC_MS_WH_UP, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_MS_BTN2, KC_VOLD, KC_VOLU, KC_MUTE, KC_PWR,
      KC_TRNS, KC_MS_WH_LEFT, KC_MS_WH_DOWN, KC_MS_WH_RIGHT, KC_TRNS, KC_TRNS, KC_MS_LEFT, KC_MS_DOWN, KC_MS_UP, KC_MS_RIGHT, KC_TRNS, KC_TRNS,
      KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_MS_BTN1, KC_MPRV, KC_MNXT, KC_MPLY, KC_TRNS,
      KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS
    )
};
