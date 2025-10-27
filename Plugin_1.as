// Documentation available at https://donadigo.com/tminterface/plugins/api

Net::Socket@ server = null;
Net::Socket@ client = null;

const string HOST = "127.0.0.1";
const uint16 PORT = 5051;

void OnRunStep(SimulationManager@ simManager)
{
    if (@client is null || !simManager.get_InRace()) return;

    uint speed = simManager.PlayerInfo.DisplaySpeed;

    client.Write(speed);
    log("Sent speed: " + speed);
}

void OnSimulationBegin(SimulationManager@ simManager)
{
}

void OnSimulationStep(SimulationManager@ simManager, bool userCancelled)
{

}

void OnSimulationEnd(SimulationManager@ simManager, SimulationResult result)
{
}

void OnCheckpointCountChanged(SimulationManager@ simManager, int count, int target)
{
}

void OnLapCountChanged(SimulationManager@ simManager, int count, int target)
{
}

void OnGameStateChanged(TM::GameState state)
{
}

void Render()
{
    // Accept a new connection if not connected
    if (@client is null) 
    {
        auto @newSock = server.Accept(0);
        if (@newSock !is null) 
        {
            @client = @newSock;
            client.NoDelay = true;
            log("C++ client connected!");
        }
    }
}

void Main()
{
    log("Plugin started.");
    @server = Net::Socket();
    bool ok = server.Listen("0.0.0.0", PORT);
    log("Server listen result: " + (ok ? "OK" : "FAILED"));
    log("SpeedStreamer started on port " + PORT);
}


void OnDisabled()
{
    @client = null;
    @server = null;
}

PluginInfo@ GetPluginInfo()
{
    auto info = PluginInfo();
    info.Name = "SpeedStreamer";
    info.Author = "Mathies Van den Bulcke";
    info.Version = "v1.0";
    info.Description = "Sends live player speed to C++ via socket.";
    return info;
}
