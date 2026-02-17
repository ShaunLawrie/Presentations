using Microsoft.AspNetCore.Mvc;
using DotnetLibrary.Orders.Services;

namespace DotnetWeb.Controllers;

[ApiController]
[Route("api/[controller]")]
public class OrdersController : ControllerBase
{
    private readonly OrderService _orderService;

    public OrdersController(OrderService orderService)
    {
        _orderService = orderService;
    }

    [HttpGet]
    public async Task<IActionResult> Get()
    {
        var response = await _orderService.GetTodaysOrdersAsync();
        return Ok(response);
    }
}
