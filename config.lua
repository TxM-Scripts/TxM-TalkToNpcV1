Config = {}
Config.Framework = "qbcore" -- "qbx" or "esx"
Config.NPCs = {
    {
        id = "support",
        name = "Support",
        role = "Support",
        model = "s_m_m_dockwork_01",
        scenario = "WORLD_HUMAN_CLIPBOARD",
        coords = vector4(201.47, -807.35, 31.03, 169.98),
        blip = {
            enable = true,
            sprite = 801,
            color = 33,
            scale = 0.5,
            name = "Support"
        },
        dialogue = {
            text = "Do you need any help?",
            options = {
                { id = 1, label = "Yes, I need help", action = "star_test" },
                { id = 2, label = "No, thank you", action = "end_test" },
            }
        }
    },
}
