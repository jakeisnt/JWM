package org.jetbrains.jwm;

import lombok.*;

@Data 
public class EventKeyboard implements Event {
    public final Key _keyCode;
    public final boolean _isPressed;
    @Getter(AccessLevel.NONE) public final KeyModifier[] _modifiers = new KeyModifier[0]; // TODO

    public EventKeyboard(Key keyCode, boolean isPressed) {
        _keyCode = keyCode;
        _isPressed = isPressed;
    }

    public boolean isModifierDown(KeyModifier modifier) {
        for (KeyModifier m: _modifiers)
            if (m == modifier)
                return true;
        return false;
    }
}