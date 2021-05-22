namespace SEPMakes.Function
{
    public interface IConfig
    {
        T Get<T>(string key);
    }
}