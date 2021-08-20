#pragma once

#include <array>
#include <string>
#include <tuple>

#pragma warning(push)
#pragma warning(disable : 4503)
#pragma warning(disable : 4996) // # The std::iterator class template (used as a base class to provide typedefs) is deprecated in C++17

namespace spark
{
    template <size_t N>
    using CharArray = std::array<char, N>;

#define STD_CHAR_ARRAY_INIT(string_literal) \
    CharArray<sizeof(string_literal)>       \
    {                                       \
        string_literal                      \
    }

    constexpr static auto key_arr = std::array<char, 50>{
        75, 116, 88, 46, 86, 31, 24, 83, 27, 12, 59, 84, 63, 55, 79, 40, 48, 23, 66, 61, 20, 51, 81, 8, 118, 28, 2, 78, 122, 60, 15, 41, 1, 44, 119, 99, 38, 7, 124, 113, 39, 57, 18, 17, 42, 50, 19, 34, 125, 114
    };

    template <typename Arr>
    constexpr size_t get_elem_with_overflow(const Arr& arr, size_t ind)
    {
        return arr[ind < arr.size() ? ind : ind % arr.size()];
    }

    inline constexpr char encipher_char(const char& c, size_t ind)
    {
        return static_cast<char>(c ^ get_elem_with_overflow(key_arr, ind));
    }

    inline constexpr char decipher_char(const char& c, size_t ind)
    {
        return static_cast<char>(c ^ get_elem_with_overflow(key_arr, ind));
    }

#pragma region variable
    template <typename Array, std::size_t... Index>
    constexpr decltype(auto) create_xor_variable_impl(const Array& arr, std::index_sequence<Index...>)
    {
        return CharArray<sizeof...(Index)>{ encipher_char(arr[Index], Index)... };
    }

    template <typename T, std::size_t N, typename Indices = std::make_index_sequence<N>>
    constexpr decltype(auto) create_xor_variable(const T (&arr)[N])
    {
        return create_xor_variable_impl(arr, Indices{});
    }

    template <std::size_t N, typename Indices = std::make_index_sequence<N>>
    constexpr decltype(auto) create_xor_variable(const CharArray<N> arr)
    {
        return create_xor_variable_impl(arr, Indices{});
    }

    template <size_t Nlhs, size_t Nrhs, std::size_t... Index>
    constexpr decltype(auto) concat_two_impl(const CharArray<Nlhs>& lhs, const CharArray<Nrhs>& rhs, std::index_sequence<Index...>)
    {
        return CharArray<sizeof...(Index)>{ encipher_char(Index < Nlhs - 1 ? decipher_char(lhs[Index], Index) : decipher_char(rhs[Index + 1 - Nlhs], Index + 1 - Nlhs), Index)... };
    }

    template <std::size_t Nlhs, std::size_t Nrhs, typename Indices = std::make_index_sequence<Nlhs + Nrhs - 1>>
    constexpr decltype(auto) concat_two(const CharArray<Nlhs>& lhs, const CharArray<Nrhs>& rhs)
    {
        return concat_two_impl(lhs, rhs, Indices{});
    }

    template <size_t N>
    class obfuscated_string_variable
    {
    public:
        const CharArray<N> text{ 0 };

        constexpr explicit obfuscated_string_variable(const char (&a)[N])
            : text(create_xor_variable(a))
        {
        }

        template <size_t Nlhs, size_t Nrhs>
        constexpr explicit obfuscated_string_variable(const obfuscated_string_variable<Nlhs>& lhs, const obfuscated_string_variable<Nrhs>& rhs)
            : text(concat_two(lhs.data(), rhs.data()))
        {
        }

        constexpr char get_original_char_at(size_t position) const
        {
            return decipher_char(text.at(position), position);
        }

        constexpr CharArray<N> data() const
        {
            return text;
        }

        constexpr size_t length() const
        {
            return text.size();
        }

        constexpr operator CharArray<N>() const
        {
            return text;
        }

        template <size_t Nr>
        constexpr auto operator+(const spark::obfuscated_string_variable<Nr>& rhs) const
        {
            return spark::obfuscated_string_variable<N + Nr - 1>(*this, rhs);
        }

        std::string get_substring(size_t start_pos, size_t end_pos) const
        {
            std::string original_text(end_pos - start_pos, 0);

            for (size_t i = start_pos; i < end_pos; ++i)
            {
                original_text[i - start_pos] = decipher_char(text[i], i);
            }

            return std::string(original_text.data());
        }

        operator std::string() const
        {
            return get_substring(0, N);
        }
    };
#pragma endregion


#pragma region array
   template< typename Tuple, std::size_t... Indices >
   constexpr auto  to_array(Tuple&& tuple, std::index_sequence<Indices...>) -> std::array< std::common_type_t<std::tuple_element_t<Indices, Tuple>...>, sizeof...(Indices)>
   {
       return { std::get<Indices>(std::forward<Tuple>(tuple))... };
   }

   template<typename Tuple>
   constexpr decltype(auto) to_array(Tuple&& tuple)
   {
        return to_array(
            std::forward<Tuple>(tuple),
            std::make_index_sequence<std::tuple_size<Tuple>::value> {} );
    }

    template <size_t N, size_t Cap>
    class obfuscated_string_array
    {
    public:
        class iterator : public std::iterator<std::input_iterator_tag, std::string>
        {
            long current_ind;
            const obfuscated_string_array<N, Cap>* array_ptr;

        public:
            explicit iterator(const obfuscated_string_array<N, Cap>* _array_ptr, size_t _current_ind)
                : current_ind(_current_ind)
                , array_ptr(_array_ptr)
            {
            }

            iterator& operator++()
            {
                current_ind++;
                return *this;
            }
            iterator operator++(int)
            {
                iterator retval = *this;
                ++(*this);
                return retval;
            }

            bool operator==(iterator other) const
            {
                return array_ptr == other.array_ptr && current_ind == other.current_ind;
            }
            bool operator!=(iterator other) const
            {
                return !(*this == other);
            }

            std::string operator*() const
            {
                return array_ptr->get_at(current_ind);
            }
        };

        iterator begin() const
        {
            return iterator(this, 0);
        }
        iterator end() const
        {
            return iterator(this, Cap);
        }

        const obfuscated_string_variable<N> buffer_impl;
        const std::array<size_t, Cap> start_indices{ 0 };

        constexpr obfuscated_string_array() = default;

        constexpr obfuscated_string_array(const obfuscated_string_variable<N>& obf_string)
            : buffer_impl(obf_string)
        {
        }

        template <size_t Nl, size_t Cl, size_t Nr>
        constexpr obfuscated_string_array(const obfuscated_string_array<Nl, Cl>& lhs_array, const obfuscated_string_variable<Nr>& rhs_string)
            : buffer_impl(lhs_array.buffer_impl + rhs_string)
            , start_indices(to_array(std::tuple_cat(lhs_array.start_indices, std::tuple<size_t>{ lhs_array.buffer_impl.length() - 1 })))
        {
        }

        template <size_t Nr>
        constexpr auto operator+(const spark::obfuscated_string_variable<Nr>& rhs) const
        {
            return spark::obfuscated_string_array<N + Nr - 1, Cap + 1>(*this, rhs);
        }


        std::string get_at(size_t ind) const
        {
            auto start_ind = start_indices[ind];
            auto end_ind = ind < Cap - 1 ? start_indices[ind + 1] : N;
            return buffer_impl.get_substring(start_ind, end_ind);
        }

        constexpr size_t size() const
        {
            return Cap;
        }

        constexpr size_t length() const
        {
            return N;
        }
    };


    template <size_t Na, size_t Ca, size_t Nr>
    constexpr static auto make_obfuscated_array_impl(const obfuscated_string_array<Na, Ca>& acc, const obfuscated_string_variable<Nr>& obf_str)
    {
        return acc + obf_str;
    }

    template <size_t Na, size_t Ca, size_t Nr, typename... Args>
    constexpr static auto make_obfuscated_array_impl(const obfuscated_string_array<Na, Ca>& acc, const obfuscated_string_variable<Nr>& obf_str, Args... args)
    {
        return make_obfuscated_array_impl(acc + obf_str, args...);
    }

    template <size_t N>
    constexpr auto make_obfuscated_array(const obfuscated_string_variable<N>& obf_str)
    {
        return obfuscated_string_array<N, 1>(obf_str);
    }

    template <size_t N, typename... Args>
    constexpr auto make_obfuscated_array(const obfuscated_string_variable<N>& obf_str, Args... args)
    {
        return make_obfuscated_array_impl(obfuscated_string_array<N, 1>(obf_str), args...);
    }
#pragma endregion
} // namespace spark

#define OBFS(str) spark::obfuscated_string_variable<sizeof(str)>(str)


#pragma warning(pop)
