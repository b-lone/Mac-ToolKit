#include "Colors.h"

#include <iomanip>
#include <sstream>


namespace SemanticVisuals
{
    Color::Color()
        : r{ 0 },
          g{ 0 },
          b{ 0 },
          a{ 0 }
    {
    }

    Color::Color(const uint8_t r, const uint8_t g, const uint8_t b,
                 const uint8_t a)
        : r{ r },
          g{ g },
          b{ b },
          a{ a }
    {
    }

    Color::Color(const std::string& hex) : Color()
    {
        if (hex.size() == 7 && hex.at(0) == '#')
        {
            try
            {
                auto asInt = std::stoul(hex.substr(1), nullptr, 16);

                b = uint8_t(asInt % 256);
                asInt /= 256;
                g = uint8_t(asInt % 256);
                asInt /= 256;
                r = uint8_t(asInt % 256);

                a = 255;
            }
            catch (std::exception&)
            {

            }
        }
    }

    [[nodiscard]] std::string Color::rgb() const
    {
        std::stringstream ss;
        ss << std::hex << std::setfill('0') << "#" << std::setw(2) << static_cast<int>(r) << std::setw(2) << static_cast<int>(g) << std::setw(2) << static_cast<int>(b);
        return ss.str();
    }

    [[nodiscard]] std::string Color::rgba() const
    {
        std::stringstream ss;
        ss << std::hex << std::setfill('0') << "#" << std::setw(2) << static_cast<int>(r) << std::setw(2) << static_cast<int>(g) << std::setw(2) << static_cast<int>(b) << std::setw(2) << static_cast<int>(a);
        return ss.str();
    }

    std::ostream& operator<<(std::ostream& os, const Color& obj)
    {
        const auto flags = os.flags();
        os << std::left << std::setw(10) << " [" << obj.rgba() << "]";
        os.flags(flags);
        return os;
    }

    bool operator==(const Color& lhs, const Color& rhs)
    {
        return std::tie(lhs.r, lhs.g, lhs.b, lhs.a) == std::tie(rhs.r, rhs.g, rhs.b, rhs.a);
    }

    bool operator!=(const Color& lhs, const Color& rhs)
    {
        return !(lhs == rhs);
    }

    ColorSet::ColorSet(const Color& normal)
        : normal(normal),
          hovered(normal),
          pressed(normal),
          disabled(normal),
          focused(normal),
          checked(normal)
    {
    }

    bool ColorSet::operator==(const ColorSet& other) const
    {
        return std::tie(normal, hovered, pressed, disabled, focused, checked) ==
            std::tie(other.normal, other.hovered, other.pressed, other.disabled, other.focused, other.checked);
    }

    ColorSet& ColorSet::setHovered(const Color c)
    {
        hovered = c;
        return *this;
    }

    ColorSet& ColorSet::setPressed(const Color c)
    {
        pressed = c;
        return *this;
    }

    ColorSet& ColorSet::setDisabled(const Color c)
    {
        disabled = c;
        return *this;
    }

    ColorSet& ColorSet::setFocused(const Color c)
    {
        focused = c;
        return *this;
    }

    ColorSet& ColorSet::setChecked(const Color c)
    {
        checked = c;
        return *this;
    }

    std::optional<Color> Colors::getColor(const std::string& name) const
    {
        if (const auto color = mColors.find(name); color != mColors.end())
        {
            return color->second;
        }
        return {};
    }

    void Colors::setColor(const std::string& name, const Color& color)
    {
        mColors[name] = color;
    }

    size_t Colors::getColorsSize() const
    {
        return mColors.size();
    }
}
