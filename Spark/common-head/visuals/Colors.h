#pragma once

#include <cstdint>
#include <optional>
#include <string>
#include <unordered_map>


namespace SemanticVisuals
{
    struct Color
    {
        Color();
        Color(uint8_t r, uint8_t g, uint8_t b, uint8_t a = 255);
        Color(const std::string& hex);

        Color(const Color& other) = default;
        Color& operator=(const Color& other) = default;

        [[nodiscard]] std::string rgb() const;
        [[nodiscard]] std::string rgba() const;
        friend std::ostream& operator<<(std::ostream& os, const Color& obj);
        friend bool operator==(const Color& lhs, const Color& rhs);
        friend bool operator!=(const Color& lhs, const Color& rhs);

        uint8_t r;
        uint8_t g;
        uint8_t b;
        uint8_t a;
    };

    struct ColorSet
    {
        ColorSet() = default;
        explicit ColorSet(const Color& normal);
        ColorSet(const ColorSet& other) = default;
        ColorSet& operator=(const ColorSet& other) = default;

        bool operator==(const ColorSet& other) const;

        ColorSet& setHovered(Color c);
        ColorSet& setPressed(Color c);
        ColorSet& setDisabled(Color c);
        ColorSet& setFocused(Color c);
        ColorSet& setChecked(Color c);

        Color normal;
        Color hovered;
        Color pressed;
        Color disabled;
        Color focused;
        Color checked;
    };

    class Colors
    {
    public:
        Colors() = default;
        Colors(const Colors& other) = default;
        Colors(Colors&& other) noexcept = default;
        Colors& operator=(const Colors& other) = default;
        Colors& operator=(Colors&& other) noexcept = default;

        [[nodiscard]] std::optional<Color> getColor(const std::string& name) const;
        void setColor(const std::string& name, const Color& color);
        [[nodiscard]] size_t getColorsSize() const;
    private:
        std::unordered_map<std::string, Color> mColors;
    };

}
