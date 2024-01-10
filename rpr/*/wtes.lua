function generate_unique_timestamp()
    local timestamp = os.date("%y%m%d_%H%M%S")
    return timestamp
end

print(generate_unique_timestamp())