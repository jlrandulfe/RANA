#include <mutex>

#include "src/output.h"
#include "src/simulationcore/interfacer.h"
#include "src/simulationcore/agents/agentluainterface.h"

Supervisor* Interfacer::master = NULL;
std::map<int, std::string> Interfacer::agentFilenames;
std::map<int, std::shared_ptr<AgentLuaInterface>> Interfacer::agents;
std::mutex Interfacer::eventMutex;
std::mutex Interfacer::agentMutex;
std::mutex Interfacer::agentPtrMutex;

void Interfacer::initInterfacer(Supervisor *arg_master)
{
	master = arg_master;
    agentFilenames.clear();
    agents.clear();
	//activesector = arg_activesector;
}

int Interfacer::addLuaAgent(double x, double y, double z, std::string path, std::string filename, std::string groupID)
{
    //std::lock_guard<std::mutex> guard(agentMutex);
    std::shared_ptr<AgentLuaInterface> luaPtr = master->addAgent(x, y, z, path, filename, groupID);
    addLuaAgentPtr(luaPtr);
    //Output::Inst()->addGraphicAgent(id,x,y);
    return luaPtr->getID();
}

void Interfacer::addLuaAgentPtr(std::shared_ptr<AgentLuaInterface> luaPtr)
{
    std::lock_guard<std::mutex> guard(agentPtrMutex);
    agents.insert(make_pair(luaPtr->getID(), luaPtr));
}

std::shared_ptr<AgentLuaInterface> Interfacer::getAgentPtr(int id)
{
    std::lock_guard<std::mutex> guard(agentPtrMutex);

	auto itr = agents.find(id);

	if(itr != agents.end())
	{
		return itr->second;
	} else return NULL;
}

bool Interfacer::removeAgent(int Id)
{
    std::lock_guard<std::mutex> guard(agentMutex);

    if(master->removeAgent(Id))
    {
        Output::Inst()->removeGraphicAgent(Id);
        return true;
    } return false;
}

std::map<int, std::string> Interfacer::getAgentInfo()
{
    return agentFilenames;
}

void Interfacer::modifyAgentInfo(std::vector<agentInfo> infolist)
{
    for(agentInfo &info : infolist)
    {
        auto &agent = agents[info.id];

        agent->setPositions(2,3,8);

    }
}

void Interfacer::submitEEvent(std::unique_ptr<EventQueue::eEvent> eEvent)
{
    std::lock_guard<std::mutex> guard(eventMutex);

    master->receiveEEventPtr(std::move(eEvent));
}
